#!/usr/bin/env bats
# Tests of apply-keycloak-theme: the theme folder in --output-dir and the optional mirror <chart-dir>/theme.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, bats-core >=1.10
bats_require_minimum_version 1.5.0
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-keycloak-theme"
LIB="$BATS_TEST_DIRNAME/../lib/common.sh"
ASSETS_DIR="$FIXTURES/assets"

setup() {
  OUT="$BATS_TEST_TMPDIR/theme-out"
  CHART="$BATS_TEST_TMPDIR/keycloak-helm"
  mkdir -p "$CHART"
}

OWNED_FILES="./email/theme.properties ./login/resources/css/brand.css ./login/resources/img/favicon.ico ./login/resources/img/favicon.svg ./login/resources/img/logo-dark.svg ./login/resources/img/logo-light.svg ./login/theme.properties "

# kc_pkg '<yq expression>' -> path of keycloak.yaml with the change applied
kc_pkg() {
  yq eval "${1:-.}" "$FIXTURES/keycloak.yaml" >"$BATS_TEST_TMPDIR/kc-mutated.yaml"
  echo "$BATS_TEST_TMPDIR/kc-mutated.yaml"
}

# kc_run '<yq expression>': run the script on the package with the change applied
kc_run() {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" "$(kc_pkg "${1:-.}")" "$ASSETS_DIR"
}

# kc_run_chart '<yq expression>': the same run with --chart-dir
kc_run_chart() {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg "${1:-.}")" "$ASSETS_DIR"
}

# tree_state <dir>: names, types and content hashes of everything below the folder
tree_state() {
  (cd "$1" && find . -print | LC_ALL=C sort && find . -type f -exec shasum {} + | LC_ALL=C sort)
}

# prop <file> <property>: value of a key in a properties file
prop() { grep -m1 "^$2=" "$1" | cut -d= -f2-; }

KC_EMAIL=$'.email.palette.primary = "#112233" | .email.palette.text = "#223344" | .email.images.logoUrl = "https://cdn.acme.example/logo.png" | .email.signature = "Best,\nThe {productName} team é"'

@test "arguments: an option after the positional arguments is rejected, nothing is written" {
  run "$SCRIPT" "$(kc_pkg)" "$ASSETS_DIR" --output-dir "$OUT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Options go before"* ]]
  [ ! -e "$OUT" ]
}

@test "arguments: the usage names --output-dir and --chart-dir, and the old flags are gone" {
  run "$SCRIPT"
  [[ "$output" == *"--output-dir"* ]]
  [[ "$output" == *"--chart-dir"* ]]
  for flag in --render-only --namespace --chart-keycloak --keycloak-timeout; do
    run "$SCRIPT" "$flag" x "$(kc_pkg)" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Unknown option: $flag"* ]]
  done
}

@test "arguments: --output-dir is required" {
  run "$SCRIPT" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--output-dir"* ]]
  [ -z "$(find "$BATS_TEST_TMPDIR" -name 'theme.properties')" ]
}

@test "output: the folder is created in any path and holds the five paths and nothing else" {
  OUT="$BATS_TEST_TMPDIR/a/b/c/my theme"
  kc_run
  [ "$status" -eq 0 ]
  [ "$(cd "$OUT" && find . -type f | LC_ALL=C sort | tr '\n' ' ')" = "$OWNED_FILES" ]
  # no stage folder stays, and no chart folder is made
  [ -z "$(find "$BATS_TEST_TMPDIR/a" -name '.kit-*')" ]
  [ ! -e "$BATS_TEST_TMPDIR/keycloak-helm/theme" ]
}

@test "output: a foreign file in the folder stays byte-equal and the folder keeps its inode" {
  mkdir -p "$OUT/login/resources/img" "$OUT/email/messages"
  printf 'custom\000bytes\n' >"$OUT/notes.txt"
  echo 'a=1' >"$OUT/email/messages/messages_en.properties"
  : >"$OUT/login/resources/img/.gitkeep"
  echo stale >"$OUT/login/resources/img/stale.png"
  echo old >"$OUT/login/theme.properties"
  cp "$OUT/notes.txt" "$BATS_TEST_TMPDIR/notes.copy"
  inode_before=$(ls -di "$OUT" | cut -d' ' -f1)
  kc_run
  [ "$status" -eq 0 ]
  cmp "$OUT/notes.txt" "$BATS_TEST_TMPDIR/notes.copy"
  [ "$(cat "$OUT/email/messages/messages_en.properties")" = "a=1" ]
  [ -e "$OUT/login/resources/img/.gitkeep" ]
  [ "$(cat "$OUT/login/resources/img/stale.png")" = "stale" ]
  [ "$(ls -di "$OUT" | cut -d' ' -f1)" = "$inode_before" ]
  [ "$(prop "$OUT/login/theme.properties" parent)" = "codemie-base" ]
}

@test "output: the images are byte copies and login brand.css is the colour rendering of the package" {
  kc_run
  [ "$status" -eq 0 ]
  for f in logo-light.svg logo-dark.svg favicon.ico favicon.svg; do
    cmp "$OUT/login/resources/img/$f" "$ASSETS_DIR/$f"
  done
  bash -c 'source "$1"; kit_render_brand_css "$2"' _ "$LIB" "$(kc_pkg)" >"$BATS_TEST_TMPDIR/expected.css"
  cmp "$OUT/login/resources/css/brand.css" "$BATS_TEST_TMPDIR/expected.css"
  grep -q -- '--colors-surface-base-primary: 17 17 17;' "$OUT/login/resources/css/brand.css"
  if grep -q -- '--font-family' "$OUT/login/resources/css/brand.css"; then false; fi
}

@test "output: no file holds a values file or a ConfigMap, and the script calls no cluster tool" {
  kc_run_chart
  [ "$status" -eq 0 ]
  [ -z "$(find "$OUT" "$CHART" -name 'values*' -o -name '*.b64')" ]
  if grep -rqE 'binaryData|extraObjects|kind: ConfigMap' "$OUT" "$CHART/theme"; then false; fi
  if grep -qE '(^|[^a-z-])(helm|kubectl|curl|base64)[[:space:]]' "$SCRIPT"; then false; fi
}

@test "last lines: one line per target written" {
  kc_run
  [ "$status" -eq 0 ]
  [ "$(tail -n 1 <<<"$stderr")" = "apply-keycloak-theme: written folder $OUT" ]
  kc_run_chart
  [ "$status" -eq 0 ]
  [ "$(tail -n 2 <<<"$stderr" | head -n 1)" = "apply-keycloak-theme: written folder $OUT" ]
  [ "$(tail -n 1 <<<"$stderr")" = "apply-keycloak-theme: written mirror $CHART/theme" ]
}

@test "no --chart-dir: no chart folder is read or written and no snippet is printed" {
  mkdir -p "$CHART/theme"
  echo keep >"$CHART/theme/file"
  before="$(tree_state "$CHART")"
  kc_run
  [ "$status" -eq 0 ]
  [ -z "$output" ]
  [ "$before" = "$(tree_state "$CHART")" ]
  [ -z "$(find "$BATS_TEST_TMPDIR" -maxdepth 1 -name 'keycloak-helm*' ! -name keycloak-helm)" ]
}

@test "mirror: --chart-dir mirrors the stage folder into <dir>/theme by whole-folder swap" {
  mkdir -p "$CHART/theme/login"
  echo old >"$CHART/theme/login/foreign.txt"
  echo foreign >"$OUT.keep"
  kc_run_chart "$KC_EMAIL"
  [ "$status" -eq 0 ]
  [ "$(cd "$CHART/theme" && find . -type f | LC_ALL=C sort | tr '\n' ' ')" = "$OWNED_FILES" ]
  diff -r "$OUT" "$CHART/theme"
  [ -z "$(find "$CHART" -name '.kit-*')" ]
}

@test "mirror: a missing --chart-dir folder is refused, nothing is written" {
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$BATS_TEST_TMPDIR/none/keycloak-helm" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"chart folder not found"* ]]
  [ ! -e "$OUT" ]
}

@test "mirror: a symlinked <chart-dir>/theme is refused and its target stays unchanged" {
  mkdir "$BATS_TEST_TMPDIR/elsewhere"
  echo keep >"$BATS_TEST_TMPDIR/elsewhere/file"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$CHART/theme"
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ "$(ls "$BATS_TEST_TMPDIR/elsewhere")" = "file" ]
  [ ! -e "$OUT" ]
}

@test "snippet: stdout holds the names-only YAML for keycloak-helm and oauth2-proxy" {
  kc_run_chart
  [ "$status" -eq 0 ]
  expected='keycloakx:
  childTheme:
    enabled: true
    name: acme-brand
    images:
      - favicon.ico
      - favicon.svg
      - logo-dark.svg
      - logo-light.svg
realm:
  themes:
    loginTheme: acme-brand
    emailTheme: acme-brand'
  [ "$(grep -v '^#' <<<"$output")" = "$expected" ]
  # the snippet is valid YAML and carries no file content
  printf '%s\n' "$output" >"$BATS_TEST_TMPDIR/snippet.yaml"
  [ "$(yq eval '.keycloakx.childTheme.images | length' "$BATS_TEST_TMPDIR/snippet.yaml")" = "4" ]
  [ "$(yq eval '.realm.themes.emailTheme' "$BATS_TEST_TMPDIR/snippet.yaml")" = "acme-brand" ]
  # no file is written for it
  [ -z "$(find "$OUT" "$CHART" -name '*.yaml')" ]
}

@test "snippet: a name shared by two assets is listed once" {
  kc_run_chart '.assets.faviconSvg = "logo-light.svg"'
  [ "$status" -eq 0 ]
  [ "$(grep -c -- '- logo-light.svg' <<<"$output")" = "1" ]
}

@test "login.theme.properties: has the contract keys" {
  kc_run
  [ "$status" -eq 0 ]
  f="$OUT/login/theme.properties"
  [ "$(prop "$f" parent)" = "codemie-base" ]
  [ "$(prop "$f" brand.version)" = "1" ]
  [ "$(prop "$f" brand.product.name)" = "Acme Suite" ]
  [ "$(prop "$f" brand.product.shortName)" = "Acme" ]
  [ "$(prop "$f" brand.logo.light)" = "logo-light.svg" ]
  [ "$(prop "$f" brand.logo.dark)" = "logo-dark.svg" ]
  [ "$(prop "$f" brand.favicon)" = "favicon.ico" ]
  [ "$(prop "$f" brand.faviconSvg)" = "favicon.svg" ]
}

@test "email.theme.properties: has parent, version, name and the email keys" {
  kc_run "$KC_EMAIL"
  [ "$status" -eq 0 ]
  f="$OUT/email/theme.properties"
  [ "$(prop "$f" parent)" = "codemie-base" ]
  [ "$(prop "$f" brand.version)" = "1" ]
  [ "$(prop "$f" brand.product.name)" = "Acme Suite" ]
  [ "$(prop "$f" brand.email.color.primary)" = "#112233" ]
  [ "$(prop "$f" brand.email.color.text)" = "#223344" ]
  [ "$(prop "$f" brand.email.logo)" = "https://cdn.acme.example/logo.png" ]
  if grep -q 'brand.email.color.primaryText' "$f"; then false; fi
  if grep -q 'brand.email.color.surface' "$f"; then false; fi
}

@test "email.theme.properties: without an email block no brand.email key is written" {
  kc_run
  [ "$status" -eq 0 ]
  if grep -q 'brand.email' "$OUT/email/theme.properties"; then false; fi
}

@test "email.theme.properties: the signature gets the product name and a newline as backslash-n on one line" {
  kc_run "$KC_EMAIL"
  [ "$status" -eq 0 ]
  f="$OUT/email/theme.properties"
  [ "$(grep -c '^brand.email.signature=' "$f")" = "1" ]
  [[ "$(grep '^brand.email.signature=' "$f")" == 'brand.email.signature=Best,\nThe Acme Suite team '* ]]
  [ "$(wc -l <"$f" | tr -d ' ')" = "$(grep -c '=' "$f")" ]
}

@test "render: an ampersand stays literal and non-ASCII text stays valid UTF-8" {
  kc_run '.product.name = "R&D Süite" | .email.signature = "Team {productName}"'
  [ "$status" -eq 0 ]
  [ "$(prop "$OUT/login/theme.properties" brand.product.name)" = "R&D Süite" ]
  [ "$(prop "$OUT/email/theme.properties" brand.email.signature)" = "Team R&D Süite" ]
  iconv -f UTF-8 -t UTF-8 "$OUT/email/theme.properties" >/dev/null
}

@test "theme name: reserved names, bad characters and bad length are refused and nothing is written" {
  for n in codemie codemie-base base keycloak Acme_Brand ab "$(printf 'a%.0s' $(seq 1 41))"; do
    run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg ".themeName = \"$n\"")" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [[ "$output" == *"themeName"* ]]
    [ ! -e "$OUT" ]
      done
}

@test "theme name: a package without themeName is refused" {
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg 'del(.themeName)')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"themeName"* ]]
  [ ! -e "$OUT" ]
}

@test "failed check: a bad token, a removed token and a missing file leave folder and mirror byte-equal" {
  kc_run_chart
  [ "$status" -eq 0 ]
  before="$(tree_state "$OUT")$(tree_state "$CHART")"
  for expr in '.email.signature = "Team ${x}"' '.email.senderName = "A"' '.smtp.host = "smtp.acme.example"' '.keycloak.themeName = "x"' '.assets.manifest = "site.webmanifest"' '.typography.bodyFamily = "Inter"' '.effects.gradients = "none"' '.assets.favicon = "absent.ico"' '.assets.logoLight = "Logo Light.svg"'; do
    run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg "$expr")" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [ "$before" = "$(tree_state "$OUT")$(tree_state "$CHART")" ]
  done
}

@test "removed tokens: senderName and smtp are named with the text to set them elsewhere" {
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg '.email.senderName = "A"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.senderName"* ]]
  [[ "$output" == *"realm settings"* ]]
  [ ! -e "$OUT" ]
}

@test "removed tokens: a top-level smtp and a keycloak block are named in the Keycloak script" {
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg '.smtp.host = "smtp.acme.example"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"smtp is removed"* ]]
  [[ "$output" == *"realm settings"* ]]
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg '.keycloak.themeName = "x"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"not a token of the Keycloak package"* ]]
  [[ "$output" != *"moved to keycloak-theme-package.yaml"* ]]
}

@test "arguments: an empty --chart-dir is refused" {
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--chart-dir needs a value"* ]]
  [ ! -e "$OUT" ]
}

@test "output guard: / . .. HOME, an empty value and a symlink are refused and nothing is written" {
  mkdir -p "$BATS_TEST_TMPDIR/home/sub" "$BATS_TEST_TMPDIR/elsewhere"
  echo keep >"$BATS_TEST_TMPDIR/home/file"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$BATS_TEST_TMPDIR/link"
  before="$(tree_state "$BATS_TEST_TMPDIR/home")"
  pkg="$(kc_pkg)"
  cd "$BATS_TEST_TMPDIR/home/sub"
  for bad in "/" "." ".." "./" "../sub/.." "$BATS_TEST_TMPDIR/home" "$BATS_TEST_TMPDIR/home/" "" "$BATS_TEST_TMPDIR/link" "$BATS_TEST_TMPDIR/link/"; do
    HOME="$BATS_TEST_TMPDIR/home" run "$SCRIPT" --output-dir "$bad" "$pkg" "$ASSETS_DIR"
    [ "$status" -ne 0 ] || { echo "accepted: '$bad'"; false; }
    [ -z "$(find "$BATS_TEST_TMPDIR/elsewhere" "$BATS_TEST_TMPDIR/home" -name theme.properties -o -name brand.css)" ]
  done
  [ "$before" = "$(tree_state "$BATS_TEST_TMPDIR/home")" ]
  [ -z "$(ls -A "$BATS_TEST_TMPDIR/elsewhere")" ]
  [ ! -e /theme.properties ] && [ ! -e /login ]
}

@test "output guard: an owned path that is a symlink or a folder is refused and its target stays unchanged" {
  mkdir -p "$OUT/login" "$BATS_TEST_TMPDIR/elsewhere"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$OUT/login/resources"
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ -z "$(ls -A "$BATS_TEST_TMPDIR/elsewhere")" ]
  [ ! -e "$OUT/email" ]
}

@test "output guard: --output-dir that is a file is refused" {
  echo x >"$OUT"
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"not a folder"* ]]
  [ "$(cat "$OUT")" = "x" ]
}

@test "path guard: an asset path outside the source folder is refused" {
  run "$SCRIPT" --output-dir "$OUT" "$(kc_pkg '.assets.logoDark = "../fixtures/assets/logo-dark.svg"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"plain file name inside the source folder"* ]]
  [ ! -e "$OUT" ]
}

@test "properties policy: the Keycloak script rejects a dollar-brace in product.name" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" "$(kc_pkg '.product.name = "Acme ${env} Suite"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$stderr" == *"product.name"* ]]
}

@test "example: acme writes the Keycloak theme folder from its own package and the shared images" {
  ex="$BATS_TEST_DIRNAME/../examples/acme"
  run "$SCRIPT" --output-dir "$OUT" "$ex/keycloak-theme-package.yaml" "$ex/assets"
  [ "$status" -eq 0 ]
  [ -f "$OUT/login/theme.properties" ]
  [ -f "$OUT/email/theme.properties" ]
  [ -f "$OUT/login/resources/img/logo-light.svg" ]
  [ -f "$OUT/login/resources/css/brand.css" ]
}
