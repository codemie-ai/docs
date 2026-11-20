#!/usr/bin/env bats
# Tests of apply-theme: the platform files written into the assets folder of the wrapper chart.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, bats-core >=1.10
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-theme"
ASSETS_DIR="$FIXTURES/assets"

setup() {
  OUT="$BATS_TEST_TMPDIR/assets"
}

# mutate '<yq expression>' -> path of a copy of valid.yaml with the change applied
mutate() {
  yq eval "$1" "$FIXTURES/valid.yaml" >"$BATS_TEST_TMPDIR/mutated.yaml"
  echo "$BATS_TEST_TMPDIR/mutated.yaml"
}

# writable copy of the asset fixtures plus the email logo fixtures
work_assets() {
  local d="$BATS_TEST_TMPDIR/source"
  if [ ! -d "$d" ]; then
    cp -R "$ASSETS_DIR" "$d"
    cp "$FIXTURES"/email-assets/* "$d/"
  fi
  echo "$d"
}

# email_pkg '<yq expression>' -> valid.yaml with a logo.png email block and the change applied
email_pkg() {
  yq eval '.email = {"signature": "The {productName} Team", "palette": {"primary": "#112233"}, "images": {"logo": "logo.png"}, "messages": {"verification": {"subject": "Verify {productName}"}}} | '"$1" \
    "$FIXTURES/valid.yaml" >"$BATS_TEST_TMPDIR/email-mutated.yaml"
  echo "$BATS_TEST_TMPDIR/email-mutated.yaml"
}

# tree_state <dir>: names, types and content hashes of everything below the folder
tree_state() {
  (cd "$1" && find . -print | LC_ALL=C sort && find . -type f -exec shasum {} + | LC_ALL=C sort)
}

# an output folder with old content that a run must replace or keep
old_output() {
  mkdir -p "$OUT/platform" "$OUT/email" "$OUT/keycloak/login"
  echo old >"$OUT/brand.css"
  echo '{}' >"$OUT/brand-config.json"
  echo old >"$OUT/platform/old.svg"
  echo old >"$OUT/email/old.png"
  : >"$OUT/platform/.gitkeep"
  : >"$OUT/email/.gitkeep"
  echo keep >"$OUT/keycloak/login/theme.properties"
  echo '# template' >"$OUT/theme-config.template.yaml"
}

# brand_yaml keys the backend loader accepts. Copies codemie/src/codemie/service/email_brand/loader.py:
# _ROOT_KEYS, _EMAIL_KEYS and the email.images check in _load_logo (only "logo"). Update with that file.
unknown_backend_keys() { yq eval "$2 | keys | .[]" "$1" | grep -vxE "$3" || true; }

@test "arguments: an option after the positional arguments is rejected, nothing is written" {
  run "$SCRIPT" "$FIXTURES/valid.yaml" "$ASSETS_DIR" --output-dir "$OUT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Options go before"* ]]
  [ ! -e "$OUT" ]
}

@test "arguments: a stray extra positional argument is rejected" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR" extra
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unexpected arguments"* ]]
}

@test "arguments: the old flags are gone" {
  for flag in --render-only --namespace --chart-ui --no-keycloak --codemie-values --customer-config --chart-dir; do
    run "$SCRIPT" "$flag" x "$FIXTURES/valid.yaml" "$ASSETS_DIR"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Unknown option: $flag"* ]]
  done
}

@test "arguments: missing positional arguments print the usage" {
  run "$SCRIPT" "$FIXTURES/valid.yaml"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Usage: apply-theme"* ]]
}

@test "output: writes exactly brand.css, brand-config.json, platform, email and nothing else" {
  mkdir "$BATS_TEST_TMPDIR/work"
  cd "$BATS_TEST_TMPDIR/work"
  mkdir codemie-ui
  run "$SCRIPT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(cd codemie-ui/assets && find . -type f | LC_ALL=C sort | tr '\n' ' ')" = "./brand-config.json ./brand.css ./email/brand.yaml ./platform/favicon.ico ./platform/favicon.svg ./platform/logo-dark.svg ./platform/logo-light.svg ./platform/site.webmanifest " ]
  # no temporary folder stays next to the output
  [ -z "$(ls -A codemie-ui | grep -v '^assets$' || true)" ]
}

@test "output: the platform files are byte copies of the source files" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  for f in logo-light.svg logo-dark.svg favicon.ico favicon.svg site.webmanifest; do
    cmp "$OUT/platform/$f" "$ASSETS_DIR/$f"
  done
}

@test "output: brand-config.json has the shape the UI reads" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  f="$OUT/brand-config.json"
  [ "$(yq eval -p=json '.product.name' "$f")" = "Acme Suite" ]
  [ "$(yq eval -p=json '.product.shortName' "$f")" = "Acme" ]
  [ "$(yq eval -p=json '.assets.logoLight' "$f")" = "logo-light.svg" ]
  [ "$(yq eval -p=json '.assets.logoDark' "$f")" = "logo-dark.svg" ]
  [ "$(yq eval -p=json '.assets.favicon' "$f")" = "favicon.ico" ]
  [ "$(yq eval -p=json '.assets.faviconSvg' "$f")" = "favicon.svg" ]
  [ "$(yq eval -p=json '.assets.manifest' "$f")" = "site.webmanifest" ]
  [ "$(yq eval -p=json 'keys | .[]' "$f" | tr '\n' ' ')" = "product assets " ]
  [ "$(yq eval -p=json '.product | keys | .[]' "$f" | tr '\n' ' ')" = "name shortName " ]
}

@test "output: no file holds base64 data, a values file or a ConfigMap" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$(work_assets)"
  [ "$status" -eq 0 ]
  for f in logo-light.svg favicon.ico; do
    b64=$(base64 <"$ASSETS_DIR/$f" | tr -d '\n')
    if grep -rqF -- "$b64" "$OUT" --exclude-dir=platform; then false; fi
  done
  [ -z "$(find "$OUT" -name 'values*' -o -name '*.b64')" ]
  if grep -rqE 'kind: ConfigMap|binaryData|extraObjects|checksum/brand' "$OUT" --exclude-dir=platform; then false; fi
}

@test "output: the script calls no helm, kubectl or curl" {
  if grep -qE '(^|[^a-z-])(helm|kubectl|curl|base64)[[:space:]]' "$SCRIPT"; then false; fi
}

@test "output: an existing folder is updated, stale files go, .gitkeep and unowned files stay" {
  old_output
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ ! -e "$OUT/platform/old.svg" ]
  [ ! -e "$OUT/email/old.png" ]
  [ -e "$OUT/platform/.gitkeep" ]
  [ -e "$OUT/email/.gitkeep" ]
  [ "$(cat "$OUT/keycloak/login/theme.properties")" = "keep" ]
  [ "$(cat "$OUT/theme-config.template.yaml")" = "# template" ]
  [ -f "$OUT/platform/logo-light.svg" ]
  [ "$(cat "$OUT/brand.css" | head -1)" = ":root {" ]
}

@test "output: a second run gives the same bytes" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  first=$(tree_state "$OUT")
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$first" = "$(tree_state "$OUT")" ]
}

@test "output: a keycloak block in the package changes nothing in keycloak/" {
  old_output
  pkg=$(mutate '.keycloak.themeName = "acme-brand"')
  before=$(tree_state "$OUT/keycloak")
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$before" = "$(tree_state "$OUT/keycloak")" ]
}

@test "brand.css: the file equals the lib render and carries the package colours" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -qx -- '  --colors-surface-base-primary: 17 17 17;' "$OUT/brand.css"
  grep -qx -- '  --font-family-body: Inter, sans-serif;' "$OUT/brand.css"
  run bash -c 'source "$1"; KIT_SCRIPT=t; PACKAGE_FILE=$2; kit_render_brand_css' _ "$BATS_TEST_DIRNAME/../lib/common.sh" "$FIXTURES/valid.yaml"
  [ "$output" = "$(cat "$OUT/brand.css")" ]
}

@test "failed check: a bad token leaves an existing output byte-equal" {
  old_output
  before=$(tree_state "$OUT")
  pkg=$(mutate '.assets.logoLight = "nope.svg"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *'assets.logoLight'* ]]
  [ "$before" = "$(tree_state "$OUT")" ]
}

@test "failed check: a bad name, a symlink and a missing file leave the output byte-equal" {
  old_output
  before=$(tree_state "$OUT")
  d=$(work_assets)
  cp "$d/logo-light.svg" "$d/Logo Light.svg"
  ln -s "$d/logo-dark.svg" "$d/linked.svg"
  for expr in '.assets.logoLight = "Logo Light.svg"' '.assets.logoDark = "linked.svg"' '.assets.favicon = "absent.ico"'; do
    pkg=$(mutate "$expr")
    run "$SCRIPT" --output-dir "$OUT" "$pkg" "$d"
    [ "$status" -ne 0 ]
    [ "$before" = "$(tree_state "$OUT")" ]
  done
  [ -z "$(ls -A "$BATS_TEST_TMPDIR" | grep '^\.kit' || true)" ]
}

@test "failed check: a removed token names the token and leaves the output byte-equal" {
  old_output
  before=$(tree_state "$OUT")
  pkg=$(mutate '.email.senderName = "Acme Notifications" | .keycloak.themeName = "acme-brand" | .keycloak.smtp.host = "smtp.acme.example"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.senderName"* ]]
  [[ "$output" == *"keycloak.smtp"* ]]
  [[ "$output" == *"realm settings"* ]]
  [ "$before" = "$(tree_state "$OUT")" ]
}

@test "path guard: a missing parent folder of --output-dir is refused" {
  run "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/none/assets" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"parent folder does not exist"* ]]
  [ ! -e "$BATS_TEST_TMPDIR/none" ]
}

@test "path guard: a symlinked --output-dir is refused and its target stays unchanged" {
  mkdir "$BATS_TEST_TMPDIR/real"
  echo keep >"$BATS_TEST_TMPDIR/real/file"
  ln -s "$BATS_TEST_TMPDIR/real" "$OUT"
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ "$(ls "$BATS_TEST_TMPDIR/real")" = "file" ]
}

@test "path guard: a symlinked platform folder is refused and its target stays unchanged" {
  mkdir -p "$OUT" "$BATS_TEST_TMPDIR/elsewhere"
  echo keep >"$BATS_TEST_TMPDIR/elsewhere/file"
  ln -s "$BATS_TEST_TMPDIR/elsewhere" "$OUT/platform"
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  [ "$(ls "$BATS_TEST_TMPDIR/elsewhere")" = "file" ]
}

@test "path guard: a symlinked brand.css is refused" {
  mkdir -p "$OUT"
  echo keep >"$BATS_TEST_TMPDIR/target.css"
  ln -s "$BATS_TEST_TMPDIR/target.css" "$OUT/brand.css"
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [ "$(cat "$BATS_TEST_TMPDIR/target.css")" = "keep" ]
}

@test "path guard: an asset path outside the source folder is refused" {
  pkg=$(mutate '.assets.logoDark = "../fixtures/assets/logo-dark.svg"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"plain file name inside the source folder"* ]]
  [ ! -e "$OUT" ]
}

@test "email: brand.yaml carries identity, email block and links; the logo is copied" {
  pkg=$(email_pkg '.')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$(work_assets)"
  [ "$status" -eq 0 ]
  by="$OUT/email/brand.yaml"
  [ "$(yq eval '.identity.productName' "$by")" = "Acme Suite" ]
  [ "$(yq eval '.email.signature' "$by")" = "The {productName} Team" ]
  [ "$(yq eval '.email.palette.primary' "$by")" = "#112233" ]
  [ "$(yq eval '.email.images.logo' "$by")" = "logo.png" ]
  [ "$(yq eval '.email.messages.verification.subject' "$by")" = "Verify {productName}" ]
  [ "$(yq eval '.links.userGuide.url' "$by")" = "https://docs.acme.example/" ]
  cmp "$OUT/email/logo.png" "$FIXTURES/email-assets/logo.png"
  [ "$(find "$OUT/email" -type f | LC_ALL=C sort | xargs -n1 basename | tr '\n' ' ')" = "brand.yaml logo.png " ]
}

@test "email: every key of brand.yaml is one the backend loader accepts" {
  pkg=$(email_pkg '.email.images.logoUrl = "https://static.acme.example/logo.png"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$(work_assets)"
  [ "$status" -eq 0 ]
  by="$OUT/email/brand.yaml"
  [ -z "$(unknown_backend_keys "$by" '.' 'identity|email|links')" ]
  [ -z "$(unknown_backend_keys "$by" '.email' 'senderName|signature|palette|images|messages')" ]
  [ -z "$(unknown_backend_keys "$by" '.email.images' 'logo')" ]
  [ "$(yq eval '.email.images | has("logoUrl")' "$by")" = "false" ]
}

@test "email: with only logoUrl set, brand.yaml has no images key" {
  pkg=$(email_pkg 'del(.email.images.logo) | .email.images.logoUrl = "https://static.acme.example/logo.png"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.email | has("images")' "$OUT/email/brand.yaml")" = "false" ]
  [ "$(yq eval '.email.palette.primary' "$OUT/email/brand.yaml")" = "#112233" ]
}

@test "email: a package without an email block writes brand.yaml with no email key and no logo" {
  run "$SCRIPT" --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval 'has("email")' "$OUT/email/brand.yaml")" = "false" ]
  [ "$(yq eval '.identity.productName' "$OUT/email/brand.yaml")" = "Acme Suite" ]
  [ "$(find "$OUT/email" -type f | wc -l | tr -d ' ')" = "1" ]
}

@test "render: an ampersand and UTF-8 in the product name stay literal in brand.yaml and brand-config.json" {
  pkg=$(mutate '.product.name = "R&D Süite"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.identity.productName' "$OUT/email/brand.yaml")" = "R&D Süite" ]
  [ "$(yq eval -p=json '.product.name' "$OUT/brand-config.json")" = "R&D Süite" ]
  iconv -f UTF-8 -t UTF-8 "$OUT/brand-config.json" >/dev/null
}

@test "example: acme writes the platform files and an email block that satisfies the backend rules" {
  ex="$BATS_TEST_DIRNAME/../examples/acme"
  run "$SCRIPT" --output-dir "$OUT" "$ex/theme-package.yaml" "$ex/assets"
  [ "$status" -eq 0 ]
  by="$OUT/email/brand.yaml"
  for role in primary primaryText text background surface; do
    yq eval ".email.palette.$role" "$by" | grep -Eq '^#[0-9A-Fa-f]{6}$'
  done
  [ -z "$(unknown_backend_keys "$by" '.' 'identity|email|links')" ]
  [ -z "$(unknown_backend_keys "$by" '.email' 'senderName|signature|palette|images|messages')" ]
  if yq eval '.email | .. | select(tag == "!!str")' "$by" | grep -oE '\{[A-Za-z0-9_]+\}' | grep -vE '^\{(productName|projectName|costCenterName)\}$'; then false; fi
  logo=$(yq eval '.email.images.logo' "$by")
  [ -n "$logo" ] && [ "$logo" != "null" ]
  [ "$(od -An -tx1 -N8 "$OUT/email/$logo" | tr -d ' \n')" = "89504e470d0a1a0a" ]
}

@test "properties policy: a platform-only run accepts a dollar-brace name that the Keycloak script rejects" {
  pkg=$(mutate '.product.name = "Acme ${env} Suite"')
  run "$SCRIPT" --output-dir "$OUT" "$pkg" "$(work_assets)"
  [ "$status" -eq 0 ]
  [ "$(yq eval -r '.product.name' "$OUT/brand-config.json")" = 'Acme ${env} Suite' ]
}
