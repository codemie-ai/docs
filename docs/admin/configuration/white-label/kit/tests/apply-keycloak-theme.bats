#!/usr/bin/env bats
# Tests of apply-keycloak-theme: the Keycloak theme files in assets/keycloak and the mirror keycloak-helm/theme.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, bats-core >=1.10
bats_require_minimum_version 1.5.0
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-keycloak-theme"
LIB="$BATS_TEST_DIRNAME/../lib/common.sh"
ASSETS_DIR="$FIXTURES/assets"

setup() {
  OUT="$BATS_TEST_TMPDIR/assets"
  CHART="$BATS_TEST_TMPDIR/keycloak-helm"
  mkdir -p "$CHART"
}

# kc_pkg '<yq expression>' -> path of keycloak.yaml with the change applied
kc_pkg() {
  yq eval "${1:-.}" "$FIXTURES/keycloak.yaml" >"$BATS_TEST_TMPDIR/kc-mutated.yaml"
  echo "$BATS_TEST_TMPDIR/kc-mutated.yaml"
}

# kc_run '<yq expression>': run the script on the package with the change applied
kc_run() {
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

@test "arguments: the usage names --chart-dir, and the old flags are gone" {
  run "$SCRIPT"
  [[ "$output" == *"--chart-dir"* ]]
  for flag in --render-only --namespace --chart-keycloak --keycloak-timeout; do
    run "$SCRIPT" "$flag" x "$(kc_pkg)" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Unknown option: $flag"* ]]
  done
}

@test "output: writes the five paths in assets/keycloak and nothing else" {
  kc_run
  [ "$status" -eq 0 ]
  [ "$(cd "$OUT" && find . -type f | LC_ALL=C sort | tr '\n' ' ')" = "./keycloak/email/theme.properties ./keycloak/login/resources/css/brand.css ./keycloak/login/resources/img/favicon.ico ./keycloak/login/resources/img/favicon.svg ./keycloak/login/resources/img/logo-dark.svg ./keycloak/login/resources/img/logo-light.svg ./keycloak/login/theme.properties " ]
  # nothing outside keycloak/ is touched and no temporary folder stays
  [ "$(ls -A "$OUT")" = "keycloak" ]
  [ "$(ls -A "$CHART")" = "theme" ]
}

@test "output: keycloak-helm/theme is a byte-equal mirror of assets/keycloak" {
  kc_run "$KC_EMAIL"
  [ "$status" -eq 0 ]
  diff -r "$OUT/keycloak" "$CHART/theme"
}

@test "output: the images are byte copies and login brand.css is the colour rendering of the package" {
  kc_run
  [ "$status" -eq 0 ]
  for f in logo-light.svg logo-dark.svg favicon.ico favicon.svg; do
    cmp "$OUT/keycloak/login/resources/img/$f" "$ASSETS_DIR/$f"
  done
  bash -c 'source "$1"; kit_render_brand_css "$2"' _ "$LIB" "$(kc_pkg)" >"$BATS_TEST_TMPDIR/expected.css"
  cmp "$OUT/keycloak/login/resources/css/brand.css" "$BATS_TEST_TMPDIR/expected.css"
  grep -q -- '--colors-surface-base-primary: 17 17 17;' "$OUT/keycloak/login/resources/css/brand.css"
  if grep -q -- '--font-family' "$OUT/keycloak/login/resources/css/brand.css"; then false; fi
}

@test "output: no file holds base64 data, a values file or a ConfigMap" {
  kc_run
  [ "$status" -eq 0 ]
  b64=$(base64 <"$ASSETS_DIR/logo-light.svg" | tr -d '\n')
  if grep -rqF -- "$b64" "$OUT/keycloak" "$CHART/theme"; then false; fi
  [ -z "$(find "$OUT" "$CHART" -name 'values*' -o -name '*.b64')" ]
  if grep -rqE 'binaryData|extraObjects|kind: ConfigMap' "$OUT/keycloak" "$CHART/theme"; then false; fi
  if grep -qE '(^|[^a-z-])(helm|kubectl|curl|base64)[[:space:]]' "$SCRIPT"; then false; fi
}

@test "output: .gitkeep and messages_en.properties stay, stale images and other owned files are replaced" {
  mkdir -p "$OUT/keycloak/login/resources/img" "$OUT/keycloak/email/messages" "$CHART/theme/login/resources/img" "$CHART/theme/email/messages"
  echo old >"$OUT/keycloak/login/resources/img/stale.png"
  echo old >"$CHART/theme/login/resources/img/stale.png"
  : >"$OUT/keycloak/login/resources/img/.gitkeep"
  echo 'a=1' >"$OUT/keycloak/email/messages/messages_en.properties"
  echo 'b=2' >"$CHART/theme/email/messages/messages_en.properties"
  echo old >"$OUT/keycloak/login/theme.properties"
  kc_run
  [ "$status" -eq 0 ]
  [ ! -e "$OUT/keycloak/login/resources/img/stale.png" ]
  [ ! -e "$CHART/theme/login/resources/img/stale.png" ]
  [ -e "$OUT/keycloak/login/resources/img/.gitkeep" ]
  [ "$(cat "$OUT/keycloak/email/messages/messages_en.properties")" = "a=1" ]
  [ "$(cat "$CHART/theme/email/messages/messages_en.properties")" = "b=2" ]
  [ "$(prop "$OUT/keycloak/login/theme.properties" parent)" = "codemie" ]
}

@test "snippet: stdout holds the names-only YAML for keycloak-helm and oauth2-proxy" {
  kc_run
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
  kc_run '.assets.faviconSvg = "logo-light.svg"'
  [ "$status" -eq 0 ]
  [ "$(grep -c -- '- logo-light.svg' <<<"$output")" = "1" ]
}

@test "login.theme.properties: has the contract keys" {
  kc_run
  [ "$status" -eq 0 ]
  f="$OUT/keycloak/login/theme.properties"
  [ "$(prop "$f" parent)" = "codemie" ]
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
  f="$OUT/keycloak/email/theme.properties"
  [ "$(prop "$f" parent)" = "codemie" ]
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
  if grep -q 'brand.email' "$OUT/keycloak/email/theme.properties"; then false; fi
}

@test "email.theme.properties: the signature gets the product name and a newline as backslash-n on one line" {
  kc_run "$KC_EMAIL"
  [ "$status" -eq 0 ]
  f="$OUT/keycloak/email/theme.properties"
  [ "$(grep -c '^brand.email.signature=' "$f")" = "1" ]
  [[ "$(grep '^brand.email.signature=' "$f")" == 'brand.email.signature=Best,\nThe Acme Suite team '* ]]
  [ "$(wc -l <"$f" | tr -d ' ')" = "$(grep -c '=' "$f")" ]
}

@test "render: an ampersand stays literal and non-ASCII text stays valid UTF-8" {
  kc_run '.product.name = "R&D Süite" | .email.signature = "Team {productName}"'
  [ "$status" -eq 0 ]
  [ "$(prop "$OUT/keycloak/login/theme.properties" brand.product.name)" = "R&D Süite" ]
  [ "$(prop "$OUT/keycloak/email/theme.properties" brand.email.signature)" = "Team R&D Süite" ]
  iconv -f UTF-8 -t UTF-8 "$OUT/keycloak/email/theme.properties" >/dev/null
}

@test "theme name: reserved names, bad characters and bad length are refused and nothing is written" {
  for n in codemie codemie-default base keycloak Acme_Brand ab "$(printf 'a%.0s' $(seq 1 41))"; do
    run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg ".themeName = \"$n\"")" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [[ "$output" == *"themeName"* ]]
    [ ! -e "$OUT" ]
    [ ! -e "$CHART/theme" ]
  done
}

@test "theme name: a package without themeName is refused" {
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg 'del(.themeName)')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"themeName"* ]]
  [ ! -e "$OUT" ]
}

@test "failed check: a bad token, a removed token and a missing file leave both outputs byte-equal" {
  kc_run
  [ "$status" -eq 0 ]
  before="$(tree_state "$OUT")$(tree_state "$CHART")"
  for expr in '.email.signature = "Team ${x}"' '.email.senderName = "A"' '.smtp.host = "smtp.acme.example"' '.assets.manifest = "site.webmanifest"' '.typography.bodyFamily = "Inter"' '.effects.gradients = "none"' '.assets.favicon = "absent.ico"' '.assets.logoLight = "Logo Light.svg"'; do
    run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg "$expr")" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [ "$before" = "$(tree_state "$OUT")$(tree_state "$CHART")" ]
  done
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg '.email.senderName = "A"')" "$ASSETS_DIR"
  [[ "$output" == *"email.senderName"* ]]
  [[ "$output" == *"realm settings"* ]]
}

@test "path guard: a missing chart folder is refused" {
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$BATS_TEST_TMPDIR/none/keycloak-helm" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"parent folder does not exist"* || "$output" == *"chart folder not found"* ]]
  [ ! -e "$OUT" ]
}

@test "path guard: a symlinked theme folder is refused and its target stays unchanged" {
  mkdir "$BATS_TEST_TMPDIR/elsewhere"
  echo keep >"$BATS_TEST_TMPDIR/elsewhere/file"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$CHART/theme"
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ "$(ls "$BATS_TEST_TMPDIR/elsewhere")" = "file" ]
  [ ! -e "$OUT/keycloak" ]
}

@test "path guard: a symlinked assets/keycloak folder and a missing parent of --output-dir are refused" {
  mkdir -p "$OUT" "$BATS_TEST_TMPDIR/elsewhere"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$OUT/keycloak"
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ -z "$(ls -A "$BATS_TEST_TMPDIR/elsewhere")" ]
  run "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/none/assets" --chart-dir "$CHART" "$(kc_pkg)" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"parent folder does not exist"* ]]
}

@test "path guard: an asset path outside the source folder is refused" {
  run "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg '.assets.logoDark = "../fixtures/assets/logo-dark.svg"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"plain file name inside the source folder"* ]]
  [ ! -e "$OUT" ]
}

@test "properties policy: the Keycloak script rejects a dollar-brace in product.name" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --chart-dir "$CHART" "$(kc_pkg '.product.name = "Acme ${env} Suite"')" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$stderr" == *"product.name"* ]]
}
