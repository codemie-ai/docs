#!/usr/bin/env bats
# Tests of lib/common.sh: input checks, removed tokens, path guards, brand.css.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, bats-core >=1.10
SCHEMA="$BATS_TEST_DIRNAME/../theme-package.schema.json"
LIB="$BATS_TEST_DIRNAME/../lib/common.sh"
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
ASSETS_DIR="$FIXTURES/assets"

# mutate '<yq expression>' -> path of a copy of valid.yaml with the change applied
mutate() {
  yq eval "$1" "$FIXTURES/valid.yaml" >"$BATS_TEST_TMPDIR/mutated.yaml"
  echo "$BATS_TEST_TMPDIR/mutated.yaml"
}

# lib '<shell code>' <package> <source-dir>: run code with the lib sourced and the inputs set
lib() {
  local code="$1"
  export T="$BATS_TEST_TMPDIR"
  shift
  run bash -c 'source "$1"; KIT_SCRIPT=test; PACKAGE_FILE=$2; SOURCE_DIR=$3; kit_init; '"$code" _ "$LIB" "${1:-$FIXTURES/valid.yaml}" "${2:-$ASSETS_DIR}"
}

# writable copy of the asset fixtures plus the email logo fixtures
work_assets() {
  local d="$BATS_TEST_TMPDIR/assets"
  if [ ! -d "$d" ]; then
    cp -R "$ASSETS_DIR" "$d"
    cp "$FIXTURES"/email-assets/* "$d/"
  fi
  echo "$d"
}

@test "schema: empty object fails validation" {
  echo '{}' >"$BATS_TEST_TMPDIR/empty.json"
  run ajv validate -s "$SCHEMA" --spec draft7 -d "$BATS_TEST_TMPDIR/empty.json"
  [ "$status" -ne 0 ]
}

@test "check_inputs: a valid package passes" {
  lib 'kit_check_inputs'
  [ "$status" -eq 0 ]
}

@test "check_inputs: a missing required field exits non-zero and names the field" {
  lib 'kit_check_inputs' "$FIXTURES/missing-product.yaml"
  [ "$status" -ne 0 ]
  [[ "$output" == *"product"* ]]
}

@test "check_inputs: reports every schema error at once, not only the first" {
  pkg=$(mutate 'del(.typography.codeFamily) | .assets.manifest = "missing.webmanifest" | .product.shortName = "" | del(.assets.favicon)')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"codeFamily"* ]]
  [[ "$output" == *"shortName"* ]]
  [[ "$output" == *"favicon"* ]]
  [[ "$output" == *"missing.webmanifest"* ]]
}

@test "check_inputs: css injection through font families, token names and !important is rejected" {
  pkg=$(mutate '.typography.bodyFamily = "x; } body { display: none" | .colors["a b{"] = {"dark": "#111111", "light": "#ffffff"} | .typography.fontFaceCSS = "@font-face { font-family: X !important; }"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"bodyFamily"* ]]
  [[ "$output" == *"colors"* ]]
  [[ "$output" == *"fontFaceCSS"* ]]
}

@test "check_inputs: unsafe link urls, braces and markup are rejected" {
  pkg=$(mutate '.links.userGuide.url = "javascript:alert(1)" | .links.videoPortal.name = "{{ .Values }}" | .product.name = "<b>Acme</b>"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"links/userGuide/url"* ]]
  [[ "$output" == *"links/videoPortal/name"* ]]
  [[ "$output" == *"product/name"* ]]
}

@test "check_inputs: a colour token without its light value and an unknown effects key are rejected" {
  pkg=$(mutate 'del(.colors."surface.base.primary".light) | .effects.shadows = "none"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"light"* ]]
  [[ "$output" == *"effects"* ]]
}

@test "check_inputs: a dollar-brace value that reaches a properties file is rejected" {
  pkg=$(mutate '.product.name = "Acme ${env} Suite"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *'product.name: must not contain ${'* ]]
}

@test "check_inputs: dollar-brace in email.signature is rejected" {
  pkg=$(mutate '.email.signature = "Team ${x}"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.signature"* ]]
}

@test "check_inputs: angle brackets, quote, backslash and control characters are rejected by field" {
  for expr in '.email.signature = "Best <b>"' '.email.signature = "Best \"x\""' '.email.signature = "A\\B"' '.email.signature = "A\tB"' '.email.palette.primary = "#11223\n"'; do
    pkg=$(mutate "$expr")
    lib 'kit_check_inputs' "$pkg"
    [ "$status" -ne 0 ]
  done
}

@test "check_inputs: a newline is allowed in email.signature, a tab next to it is not" {
  pkg=$(mutate '.email.signature = "Best,\n{productName} team"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -eq 0 ]
  pkg=$(mutate '.email.signature = "Best,\n\tteam"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.signature: must not contain control characters"* ]]
}

@test "check_inputs: leading or trailing whitespace is rejected" {
  pkg=$(mutate '.email.signature = " Team"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.signature: must not start or end with whitespace"* ]]
  pkg=$(mutate '.email.signature = "Team "')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
}

@test "check_inputs: a missing asset file is rejected and named" {
  pkg=$(mutate '.assets.logoDark = "absent.svg"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"assets.logoDark: file not found"* ]]
}

@test "check_inputs: a symlinked asset is rejected" {
  d=$(work_assets)
  ln -s "$d/logo-dark.svg" "$d/linked.svg"
  pkg=$(mutate '.assets.logoDark = "linked.svg"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [ "$status" -ne 0 ]
  [[ "$output" == *"assets.logoDark: must not be a symbolic link"* ]]
}

@test "check_inputs: the name Logo Light.svg is rejected" {
  d=$(work_assets)
  cp "$d/logo-light.svg" "$d/Logo Light.svg"
  pkg=$(mutate '.assets.logoLight = "Logo Light.svg"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [ "$status" -ne 0 ]
  [[ "$output" == *"assets.logoLight"* ]]
}

@test "check_inputs: an asset name with a path is rejected as outside the source folder" {
  pkg=$(mutate '.assets.logoDark = "../../etc/passwd"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"assets.logoDark: must be a plain file name inside the source folder"* ]]
}

@test "check_inputs: the email logo follows the same name, symlink and existence rules" {
  d=$(work_assets)
  ln -s "$d/logo.png" "$d/linked.png"
  pkg=$(mutate '.email.images.logo = "linked.png"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.images.logo: must not be a symbolic link"* ]]
  pkg=$(mutate '.email.images.logo = "absent.png"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [[ "$output" == *"email.images.logo: file not found"* ]]
  pkg=$(mutate '.email.images.logo = "a b.png"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [[ "$output" == *"email.images.logo"* ]]
}

@test "check_inputs: size, email-logo content and link cross-checks are not made" {
  d=$(work_assets)
  # a logo whose bytes are not a PNG and a very large asset both pass: the charts and the harness own those checks
  cp "$FIXTURES/email-assets/bad-magic.png" "$d/bad.png"
  head -c 2000000 /dev/zero >"$d/big.svg"
  pkg=$(mutate '.email.images.logo = "bad.png" | .assets.logoDark = "big.svg"')
  lib 'kit_check_inputs' "$pkg" "$d"
  [ "$status" -eq 0 ]
}

@test "removed tokens: email.senderName is named and points to the realm settings" {
  pkg=$(mutate '.email.senderName = "Acme Notifications"')
  lib 'kit_removed_tokens' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.senderName"* ]]
  [[ "$output" == *"realm settings"* ]]
  [[ "$output" == *"EMAIL_FROM_NAME"* ]]
}

@test "removed tokens: keycloak.smtp is named and points to the realm settings" {
  pkg=$(mutate '.keycloak.themeName = "acme-brand" | .keycloak.smtp.host = "smtp.acme.example"')
  lib 'kit_removed_tokens' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"keycloak.smtp"* ]]
  [[ "$output" == *"realm settings"* ]]
}

@test "removed tokens: both are listed together, and a clean package passes" {
  pkg=$(mutate '.email.senderName = "A" | .keycloak.themeName = "acme-brand" | .keycloak.smtp = {}')
  lib 'kit_removed_tokens' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"email.senderName"* ]]
  [[ "$output" == *"keycloak.smtp"* ]]
  lib 'kit_removed_tokens'
  [ "$status" -eq 0 ]
}

@test "theme name: reserved names are rejected" {
  for n in codemie codemie-default base keycloak; do
    pkg=$(mutate ".keycloak.themeName = \"$n\"")
    lib 'kit_check_theme_name' "$pkg"
    [ "$status" -ne 0 ]
    [[ "$output" == *"keycloak.themeName"* ]]
    [[ "$output" == *"reserved"* ]]
  done
}

@test "theme name: length and characters are checked, a good name passes" {
  for n in ab Acme_Brand "$(printf 'a%.0s' $(seq 1 41))"; do
    pkg=$(mutate ".keycloak.themeName = \"$n\"")
    lib 'kit_check_theme_name' "$pkg"
    [ "$status" -ne 0 ]
  done
  pkg=$(mutate '.keycloak.themeName = "acme-brand"')
  lib 'kit_check_theme_name' "$pkg"
  [ "$status" -eq 0 ]
}

@test "theme name: a package without the keycloak block is rejected naming keycloak.themeName" {
  pkg=$(mutate 'del(.keycloak)')
  lib 'kit_check_theme_name' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"keycloak.themeName: required"* ]]
}

@test "path guard: a missing parent folder is refused" {
  lib 'kit_guard_target "$T/none/assets" brand.css'
  [ "$status" -ne 0 ]
  [[ "$output" == *"parent folder does not exist"* ]]
}

@test "path guard: a symlinked target folder is refused" {
  mkdir "$BATS_TEST_TMPDIR/real"
  ln -s "$BATS_TEST_TMPDIR/real" "$BATS_TEST_TMPDIR/link"
  lib 'kit_guard_target "$T/link" brand.css'
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
}

@test "path guard: a symlink at or below an owned path is refused" {
  mkdir -p "$BATS_TEST_TMPDIR/o/platform"
  ln -s "$ASSETS_DIR/logo-light.svg" "$BATS_TEST_TMPDIR/o/platform/x.svg"
  lib 'kit_guard_target "$T/o" brand.css platform'
  [ "$status" -ne 0 ]
  [[ "$output" == *"symbolic link"* ]]
  rm -rf "$BATS_TEST_TMPDIR/o"
  mkdir -p "$BATS_TEST_TMPDIR/o"
  ln -s "$ASSETS_DIR/logo-light.svg" "$BATS_TEST_TMPDIR/o/brand.css"
  lib 'kit_guard_target "$T/o" brand.css platform'
  [ "$status" -ne 0 ]
}

@test "path guard: a plain folder, an absent folder with a parent, and an unowned symlink pass" {
  mkdir -p "$BATS_TEST_TMPDIR/o"
  ln -s "$ASSETS_DIR" "$BATS_TEST_TMPDIR/o/other"
  lib 'kit_guard_target "$T/o" brand.css platform'
  [ "$status" -eq 0 ]
  lib 'kit_guard_target "$T/absent" brand.css platform'
  [ "$status" -eq 0 ]
}

@test "swap: a staged folder replaces the target, and the old content is gone" {
  mkdir -p "$BATS_TEST_TMPDIR/t" "$BATS_TEST_TMPDIR/s"
  echo old >"$BATS_TEST_TMPDIR/t/old.txt"
  echo new >"$BATS_TEST_TMPDIR/s/new.txt"
  lib 'kit_swap_dir "$T/s" "$T/t"'
  [ "$status" -eq 0 ]
  [ -f "$BATS_TEST_TMPDIR/t/new.txt" ]
  [ ! -e "$BATS_TEST_TMPDIR/t/old.txt" ]
  [ ! -e "$BATS_TEST_TMPDIR/s" ]
  # no backup folder stays next to the target
  [ "$(ls -A "$BATS_TEST_TMPDIR" | grep -c '^\.kit')" -eq 0 ]
}

@test "brand.css: the variable names the UI reads, dark and light blocks, no colours in :root" {
  lib 'kit_render_brand_css'
  [ "$status" -eq 0 ]
  css="$BATS_TEST_TMPDIR/brand.css"
  printf '%s\n' "$output" >"$css"
  grep -qx -- '  --font-family-body: Inter, sans-serif;' "$css"
  grep -qx -- '  --font-family-body-prose: Georgia, serif;' "$css"
  grep -qx -- '  --font-family-code-block: Fira Code, monospace;' "$css"
  grep -qx -- '  --colors-surface-base-primary: 17 17 17;' "$css"
  [ "$(grep -c '^html.codemieDark {' "$css")" -eq 1 ]
  [ "$(grep -c '^html.codemieLight {' "$css")" -eq 1 ]
  light=$(sed -n '/^html.codemieLight {/,/^}/p' "$css")
  [[ "$light" == *"--colors-surface-base-primary: 255 255 255;"* ]]
  root=$(sed -n '/^:root {/,/^}/p' "$css")
  ! [[ "$root" == *"--colors-"* ]]
  ! grep -q -- '!important\|--brand-gradients' "$css"
}

@test "brand.css: effects.gradients none writes the option and single-colour gradients in both themes" {
  pkg=$(mutate '.effects.gradients = "none" | .colors["border.specific.primary-button-to"] = {"dark": "#111111", "light": "#222222"}')
  lib 'kit_render_brand_css' "$pkg"
  [ "$status" -eq 0 ]
  printf '%s\n' "$output" >"$BATS_TEST_TMPDIR/brand.css"
  css="$BATS_TEST_TMPDIR/brand.css"
  [[ "$(sed -n '/^:root {/,/^}/p' "$css")" == *"  --brand-gradients: none;"* ]]
  for theme in codemieDark codemieLight; do
    block=$(sed -n "/^html.$theme {/,/^}/p" "$css")
    [[ "$block" == *"--colors-border-specific-primary-button-to: var(--colors-border-specific-primary-button-from);"* ]]
    [[ "$block" == *"--colors-surface-specific-swatch-gradient-via: var(--colors-surface-specific-swatch-gradient-from);"* ]]
  done
  block=$(sed -n '/^html.codemieDark {/,/^}/p' "$css")
  first=$(grep -n -- '--colors-border-specific-primary-button-to: 17 17 17' <<<"$block" | cut -d: -f1)
  last=$(grep -n -- '--colors-border-specific-primary-button-to: var(' <<<"$block" | cut -d: -f1)
  [ "$first" -lt "$last" ]
}

@test "brand.css: multi-line fontFaceCSS comes first and appears once" {
  pkg=$(mutate '.typography.fontFaceCSS = "@font-face {\n  font-family: Inter;\n  src: url(https://fonts.acme.example/inter.woff2);\n}"')
  lib 'kit_render_brand_css' "$pkg"
  [ "$status" -eq 0 ]
  printf '%s\n' "$output" >"$BATS_TEST_TMPDIR/brand.css"
  [ "$(head -1 "$BATS_TEST_TMPDIR/brand.css")" = "@font-face {" ]
  [ "$(grep -c 'font-family: Inter;' "$BATS_TEST_TMPDIR/brand.css")" -eq 1 ]
}

@test "brand values: an ampersand and UTF-8 in the product name stay literal" {
  pkg=$(mutate '.product.name = "R&D Süite"')
  lib 'kit_read_brand; printf "%s|%s" "$PRODUCT_NAME" "$PRODUCT_SHORT"' "$pkg"
  [ "$status" -eq 0 ]
  [ "$output" = "R&D Süite|Acme" ]
}

# token_paths <file>: dotted paths of every token line, commented out or not. A token line is a
# lower-case key with no value, or a value of a plain form (string, number, boolean, null, {...}).
# Explanatory comment lines never have that form; keys with dots (colour tokens) are not token lines.
token_paths() {
  awk '
    { line = $0; sub(/^# ?/, "", line) }
    match(line, /^ *[a-z][A-Za-z0-9_]*:/) {
      head = substr(line, 1, RLENGTH - 1); rest = substr(line, RLENGTH + 1)
      if (rest !~ /^$/ && rest !~ /^ *#/ && rest !~ /^ +(\x27[^\x27]*\x27|-?[0-9]+|true|false|null|\{[^}]*\})( +#.*)?$/) next
      indent = match(head, /[^ ]/) - 1; key = substr(head, indent + 1)
      while (depth > 0 && ind[depth] >= indent) depth--
      depth++; ind[depth] = indent; name[depth] = key
      path = name[1]; for (i = 2; i <= depth; i++) path = path "." name[i]
      print path
    }
  ' "$1" | LC_ALL=C sort -u
}

# schema_paths: dotted path of every property of the schema; the free-form colors map is one path
schema_paths() {
  node -e '
    const s = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    const out = new Set();
    const walk = (n, p) => {
      if (n.$ref) n = n.$ref.split("/").slice(1).reduce((a, k) => a[k], s);
      for (const [k, v] of Object.entries(n.properties || {})) {
        const q = p ? p + "." + k : k;
        out.add(q);
        walk(v, q);
      }
    };
    walk(s, "");
    console.log([...out].join("\n"));
  ' "$SCHEMA" | LC_ALL=C sort -u
}

@test "template: the token paths of theme-config.template.yaml equal the schema properties" {
  [ -n "$(schema_paths)" ]
  [ "$(token_paths "$BATS_TEST_DIRNAME/../theme-config.template.yaml")" = "$(schema_paths)" ]
}

@test "template: the token paths of theme-package.yaml equal those of theme-config.template.yaml" {
  [ "$(token_paths "$BATS_TEST_DIRNAME/../theme-package.yaml")" = "$(token_paths "$BATS_TEST_DIRNAME/../theme-config.template.yaml")" ]
}

@test "template: theme-config.template.yaml has every token commented out and no senderName or smtp" {
  f="$BATS_TEST_DIRNAME/../theme-config.template.yaml"
  [ -z "$(grep -vE '^(#|$)' "$f")" ]
  ! grep -qE 'senderName|smtp' "$f" "$BATS_TEST_DIRNAME/../theme-package.yaml"
}

@test "template: the awk reader sees a changed token (guard against a reader that finds nothing)" {
  sed "s/^# product:/# prodct:/" "$BATS_TEST_DIRNAME/../theme-config.template.yaml" >"$BATS_TEST_TMPDIR/t.yaml"
  [ "$(token_paths "$BATS_TEST_TMPDIR/t.yaml")" != "$(schema_paths)" ]
}

@test "schema: senderName and smtp are rejected as unknown keys" {
  pkg=$(mutate '.email.senderName = "A" | .keycloak.smtp.host = "smtp.acme.example"')
  lib 'kit_check_inputs' "$pkg"
  [ "$status" -ne 0 ]
  [[ "$output" == *"additional properties"* ]]
  [[ "$output" == *"data/email must NOT have additional properties"* ]]
  [[ "$output" == *"data/keycloak must NOT have additional properties"* ]]
}

@test "example: the acme example passes the input checks and renders brand.css" {
  ex="$BATS_TEST_DIRNAME/../examples/acme"
  lib 'kit_check_inputs && kit_render_brand_css >/dev/null' "$ex/theme-package.yaml" "$ex/assets"
  [ "$status" -eq 0 ]
}

@test "example: the empty template still fails the input checks" {
  lib 'kit_check_inputs' "$BATS_TEST_DIRNAME/../theme-package.yaml"
  [ "$status" -ne 0 ]
}

# ── contract with the charts ─────────────────────────────────────────────────

CHARTS="$BATS_TEST_DIRNAME/../../../../../../../codemie-helm-charts"
CONTRACT="$FIXTURES/contract/chart-values-keys.txt"

# contract_lines <kind>: the values of the fixture lines of one kind
contract_lines() { grep -E "^$1 " "$CONTRACT" | cut -d' ' -f2-; }

# need_charts: skip with a visible message when the charts repository is not next to this one
need_charts() {
  if [ ! -d "$CHARTS/keycloak-helm" ]; then
    skip "codemie-helm-charts not found at $CHARTS: contract lines are not checked against the charts"
  fi
}

@test "contract: the fixture holds the new keys, the name regex and the assets layout" {
  [ -n "$(contract_lines key | grep -x 'keycloakx.childTheme.images')" ]
  [ -n "$(contract_lines key | grep -x 'keycloakx.childTheme.folder')" ]
  [ "$(contract_lines text | grep -c '^login/\|^email/')" = "5" ]
  [ -n "$(contract_lines text | grep -xF 'keycloak-child-theme')" ]
  [ -n "$(contract_lines text | grep -xF '^[A-Za-z0-9][A-Za-z0-9._-]{0,99}$')" ]
  [ "$(contract_lines layout | tr '\n' ' ')" = "brand.css brand-config.json platform/* email/* email/brand.yaml keycloak " ]
}

@test "contract: the fixture lists no childTheme.data, binaryData, 400000, img. prefix or realm.smtp" {
  ! grep -E 'childTheme\.data|childTheme\.binaryData|binaryData|400000|img\.|realm\.smtp' "$CONTRACT"
}

@test "contract: the asset-name regex of the fixture is the regex of the lib" {
  source "$LIB"
  [ "$(contract_lines text | grep -F '^[A-Za-z0-9]')" = "$KIT_ASSET_NAME_RE" ]
}

@test "contract: every key line is found in the values files of the charts" {
  need_charts
  for k in $(contract_lines key); do
    parent="${k%.*}"
    last="${k##*.}"
    found=no
    for f in "$CHARTS/keycloak-helm/values-aws.yaml" "$CHARTS/oauth2-proxy/values-aws.yaml"; do
      if [ "$k" = "keycloakx.childTheme" ] || [ "$parent" = "$k" ]; then
        [ "$(yq eval ".$k | tag" "$f")" = "!!map" ] && found=yes
      else
        [ "$(yq eval ".$parent | has(\"$last\")" "$f" 2>/dev/null)" = "true" ] && found=yes
      fi
    done
    [ "$found" = "yes" ] || { echo "key not found in the charts: $k"; return 1; }
  done
}

@test "contract: every text line is found in the Keycloak chart templates" {
  need_charts
  for t in $(contract_lines text | grep -v '^\^'); do
    grep -rqF -- "$t" "$CHARTS/keycloak-helm/templates" || { echo "text not found in the charts: $t"; return 1; }
  done
  # the regex line is found after removing its anchors
  re=$(contract_lines text | grep '^\^')
  grep -rqF -- "$re" "$CHARTS/keycloak-helm/templates" || { echo "regex not found in the charts: $re"; return 1; }
}

@test "contract: every layout line is found in the wrapper chart" {
  need_charts
  for l in $(contract_lines layout); do
    case "$l" in
      keycloak) grep -qxF 'assets/keycloak' "$CHARTS/codemie-ui/.helmignore" ;;
      email/brand.yaml) grep -qF 'brand.yaml' "$CHARTS/codemie-ui/templates/brand-configmaps.yaml" ;;
      *) grep -qF "\"$l\"" "$CHARTS/codemie-ui/templates/_helpers.tpl" ;;
    esac || { echo "layout not found in the charts: $l"; return 1; }
  done
}

@test "contract: the brand-input lines equal codemie-ui/brand-inputs.txt, listed as a chart file" {
  need_charts
  [ "$(contract_lines brand-input)" = "$(cat "$CHARTS/codemie-ui/brand-inputs.txt")" ]
  grep -qx '# chart file, not script output: codemie-ui/brand-inputs.txt' "$CONTRACT"
}

@test "contract: the paths both scripts write are paths of the fixture layout" {
  mkdir -p "$BATS_TEST_TMPDIR/chart"
  pkg=$(mutate '.keycloak.themeName = "acme-brand" | .email.images.logo = "logo.png"')
  d=$(work_assets)
  run "$BATS_TEST_DIRNAME/../apply-theme" --output-dir "$BATS_TEST_TMPDIR/out" "$pkg" "$d"
  [ "$status" -eq 0 ]
  run "$BATS_TEST_DIRNAME/../apply-keycloak-theme" --output-dir "$BATS_TEST_TMPDIR/out" --chart-dir "$BATS_TEST_TMPDIR/chart" "$pkg" "$d"
  [ "$status" -eq 0 ]
  layout=$(contract_lines layout)
  text=$(contract_lines text)
  # platform script paths: each is a layout path (a * covers one folder of files)
  while IFS= read -r f; do
    case "$f" in
      brand.css | brand-config.json | email/brand.yaml) grep -qxF "$f" <<<"$layout" ;;
      platform/*) grep -qxF 'platform/*' <<<"$layout" ;;
      email/*) grep -qxF 'email/*' <<<"$layout" ;;
      keycloak/*) grep -qxF 'keycloak' <<<"$layout" && p="${f#keycloak/}" && { grep -qxF "$p" <<<"$text" || grep -qxF "${p%/*}/" <<<"$text"; } ;;
      *) false ;;
    esac || { echo "path not in the fixture layout: $f"; return 1; }
  done < <(cd "$BATS_TEST_TMPDIR/out" && find . -type f | sed 's#^\./##')
  # every fixture layout path has output, and the mirror has the five paths
  [ -f "$BATS_TEST_TMPDIR/out/brand.css" ] && [ -f "$BATS_TEST_TMPDIR/out/brand-config.json" ] && [ -d "$BATS_TEST_TMPDIR/out/platform" ]
  for t in login/theme.properties login/resources/css/brand.css email/theme.properties; do
    [ -f "$BATS_TEST_TMPDIR/chart/theme/$t" ]
  done
  [ "$(ls "$BATS_TEST_TMPDIR/chart/theme/login/resources/img" | wc -l | tr -d ' ')" = "4" ]
}
