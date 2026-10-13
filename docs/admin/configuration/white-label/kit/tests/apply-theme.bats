#!/usr/bin/env bats
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, bats-core >=1.10
SCHEMA="$BATS_TEST_DIRNAME/../theme-package.schema.json"
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-theme"
ASSETS_DIR="$BATS_TEST_DIRNAME/fixtures/assets"
STUBS="$BATS_TEST_DIRNAME/stubs"

setup() {
  rm -f "$BATS_TMPDIR/helm-calls" "$BATS_TMPDIR/kubectl-calls"
  export CUSTOMER_CONFIG_PATH="$FIXTURES/customer-config.yaml"
  OUT="$BATS_TEST_TMPDIR/out"
}

# mutate '<yq expression>' -> path of a copy of valid.yaml with the change applied
mutate() {
  yq eval "$1" "$FIXTURES/valid.yaml" >"$BATS_TEST_TMPDIR/mutated.yaml"
  echo "$BATS_TEST_TMPDIR/mutated.yaml"
}

apply_args() {
  echo --release-ui my-ui --release-codemie my-backend --chart-ui repo/ui --chart-codemie repo/api
}

@test "schema: empty object fails validation" {
  echo '{}' >"$BATS_TEST_TMPDIR/empty.json"
  run ajv validate -s "$SCHEMA" --spec draft7 -d "$BATS_TEST_TMPDIR/empty.json"
  [ "$status" -ne 0 ]
}

@test "validate: missing required field exits non-zero and names the field" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/missing-product.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"product"* ]]
  [ ! -e "$OUT/brand.css" ]
}

@test "validate: reports every problem at once, not only the first" {
  pkg=$(mutate 'del(.typography.codeFamily) | .assets.manifest = "missing.webmanifest" | .product.shortName = "" | del(.links.customerSupport)')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"codeFamily"* ]]
  [[ "$output" == *"shortName"* ]]
  [[ "$output" == *"missing.webmanifest"* ]]
  [[ "$output" == *"links.customerSupport"* ]]
  [ ! -e "$OUT/brand.css" ]
}

@test "validate: enabled link absent from package exits non-zero naming the link" {
  run "$SCRIPT" --render-only "$FIXTURES/missing-link.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"links.customerSupport"* ]]
}

@test "validate: --customer-config option is honoured without the environment variable" {
  unset CUSTOMER_CONFIG_PATH
  run "$SCRIPT" --render-only --customer-config "$FIXTURES/customer-config.yaml" \
    "$FIXTURES/missing-link.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"links.customerSupport"* ]]
}

@test "validate: an unreadable customer config path is an error, not a silent skip" {
  run "$SCRIPT" --render-only --customer-config "$BATS_TEST_TMPDIR/absent.yaml" \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"customer config not found"* ]]
}

@test "validate: missing customer config warns that the link check is skipped" {
  unset CUSTOMER_CONFIG_PATH
  [ ! -f /app/config/customer/customer-config.yaml ] && [ ! -f /etc/codemie/customer-config.yaml ] || skip "host has a customer config"
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/missing-link.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [[ "$output" == *"SKIPPED"* ]]
}

@test "validate: valid package passes" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
}

@test "validate: asset names cannot escape the assets directory" {
  pkg=$(mutate '.assets.logoDark = "../../etc/passwd"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"assets/logoDark"* ]]
  [ ! -e "$OUT/values-codemie-ui.brand.yaml" ]
}

@test "validate: duplicate asset names are rejected" {
  pkg=$(mutate '.assets.favicon = "logo-dark.svg"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"unique"* ]]
}

@test "validate: assets above the ConfigMap size limit are rejected" {
  big="$BATS_TEST_TMPDIR/assets"
  cp -R "$ASSETS_DIR" "$big"
  head -c 900000 /dev/zero >"$big/logo-dark.svg"
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$big"
  [ "$status" -ne 0 ]
  [[ "$output" == *"1 MiB"* ]]
}

@test "validate: unsafe link urls, braces and markup are rejected" {
  pkg=$(mutate '.links.userGuide.url = "javascript:alert(1)" | .links.videoPortal.name = "{{ .Values }}" | .product.name = "<b>Acme</b>"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"links/userGuide/url"* ]]
  [[ "$output" == *"links/videoPortal/name"* ]]
  [[ "$output" == *"product/name"* ]]
}

@test "validate: css injection through font families, token names and !important is rejected" {
  pkg=$(mutate '.typography.bodyFamily = "x; } body { display: none" | .colors["a b{"] = {"dark": "#111111", "light": "#ffffff"} | .typography.fontFaceCSS = "@font-face { font-family: X !important; }"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"bodyFamily"* ]]
  [[ "$output" == *"colors"* ]]
  [[ "$output" == *"fontFaceCSS"* ]]
}

@test "render-only: writes all output files to --output-dir without calling helm or kubectl" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ -f "$OUT/brand.css" ]
  [ -f "$OUT/values-codemie-ui.brand.yaml" ]
  [ -f "$OUT/values-codemie.brand.yaml" ]
  [ ! -f "$BATS_TMPDIR/helm-calls" ]
  [ ! -f "$BATS_TMPDIR/kubectl-calls" ]
}

@test "brand.css: emits the exact variable names the UI reads" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  css="$OUT/brand.css"
  grep -qx -- '  --font-family-body: Inter, sans-serif;' "$css"
  grep -qx -- '  --font-family-body-prose: Georgia, serif;' "$css"
  grep -qx -- '  --font-family-code-block: Fira Code, monospace;' "$css"
  # multi-dot token paths lose every dot; values are space-separated rgb channels
  grep -qx -- '  --colors-surface-base-primary: 17 17 17;' "$css"
  grep -qx -- '  --colors-text-specific-navigation-link: 10 11 12;' "$css"
  ! grep -q -- 'bodyFamily\|codeFamily\|-dark:\|-light:\|!important' "$css"
}

@test "brand.css: dark and light values are emitted together, each under its own theme class" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  css="$OUT/brand.css"
  [ "$(grep -c '^html.codemieDark {' "$css")" -eq 1 ]
  [ "$(grep -c '^html.codemieLight {' "$css")" -eq 1 ]
  dark=$(sed -n '/^html.codemieDark {/,/^}/p' "$css")
  light=$(sed -n '/^html.codemieLight {/,/^}/p' "$css")
  [[ "$dark" == *"--colors-surface-base-primary: 17 17 17;"* ]]
  [[ "$light" == *"--colors-surface-base-primary: 255 255 255;"* ]]
  # the two blocks carry the same variable names, so a token never exists in one theme only
  [ "$(printf '%s\n' "$dark" | grep -o -- '--colors-[a-z-]*' | sort)" = "$(printf '%s\n' "$light" | grep -o -- '--colors-[a-z-]*' | sort)" ]
  # colours are never in :root, so the built-in theme selectors cannot outrank them
  root=$(sed -n '/^:root {/,/^}/p' "$css")
  ! [[ "$root" == *"--colors-"* ]]
}

@test "validate: a colour token without its light or dark value is rejected" {
  pkg=$(mutate 'del(.colors."surface.base.primary".light)')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"light"* ]]
  [ ! -e "$OUT/brand.css" ]
}

@test "brand.css: multi-line fontFaceCSS comes first and appears exactly once" {
  pkg=$(mutate '.typography.fontFaceCSS = "@font-face {\n  font-family: Inter;\n  src: url(https://fonts.acme.example/inter.woff2);\n}"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(head -1 "$OUT/brand.css")" = "@font-face {" ]
  [ "$(grep -c 'font-family: Inter;' "$OUT/brand.css")" -eq 1 ]
  [ "$(grep -c '^:root {' "$OUT/brand.css")" -eq 1 ]
}

@test "render-only: rendered files contain checksum annotation" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  ui=$(yq eval '.brand.podAnnotations."checksum/brand"' "$OUT/values-codemie-ui.brand.yaml")
  api=$(yq eval '.podAnnotations."checksum/brand"' "$OUT/values-codemie.brand.yaml")
  [[ "$ui" =~ ^[0-9a-f]{64}$ ]]
  [ "$ui" = "$api" ]
}

@test "render-only: checksum changes when only an asset file changes" {
  run "$SCRIPT" --render-only --output-dir "$OUT/a" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  cp -R "$ASSETS_DIR" "$BATS_TEST_TMPDIR/assets2"
  echo "<!-- edited -->" >>"$BATS_TEST_TMPDIR/assets2/logo-dark.svg"
  run "$SCRIPT" --render-only --output-dir "$OUT/b" "$FIXTURES/valid.yaml" "$BATS_TEST_TMPDIR/assets2"
  [ "$status" -eq 0 ]
  a=$(yq eval '.podAnnotations."checksum/brand"' "$OUT/a/values-codemie.brand.yaml")
  b=$(yq eval '.podAnnotations."checksum/brand"' "$OUT/b/values-codemie.brand.yaml")
  [ "$a" != "$b" ]
}

@test "values-codemie-ui: carries product, assets, css and base64 data; sets no chart version or image" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie-ui.brand.yaml"
  [ "$(yq eval '.brand.enabled' "$f")" = "true" ]
  [ "$(yq eval '.brand.product.name' "$f")" = "Acme Suite" ]
  [ "$(yq eval '.brand.assets.logoDark' "$f")" = "logo-dark.svg" ]
  [ "$(yq eval '.brand.logoDarkData' "$f")" = "$(base64 <"$ASSETS_DIR/logo-dark.svg" | tr -d '\n')" ]
  [ "$(yq eval '.brand.brandCssContent' "$f")" = "$(cat "$OUT/brand.css")" ]
  [ "$(yq eval 'has("image")' "$f")" = "false" ]
}

@test "values-codemie: mounts brand.yaml into the API pod at the path the backend reads" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval '.[] | select(.name == "codemie-brand") | .mountPath' -)" = "/etc/codemie/brand.yaml" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval '.[] | select(.name == "codemie-brand") | .subPath' -)" = "brand.yaml" ]
  [ "$(yq eval '.extraVolumes' "$f" | yq eval '.[] | select(.name == "codemie-brand") | .configMap.name' -)" = "codemie-brand" ]
  [ "$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .kind' "$f")" = "ConfigMap" ]
  [ "$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .data."brand.yaml"' "$f" | yq eval '.links.userGuide.url' -)" = "https://docs.acme.example/" ]
  [ "$(yq eval 'has("image")' "$f")" = "false" ]
}

@test "values-codemie: brand entries are merged into the release's existing lists and stay idempotent" {
  cat >"$BATS_TEST_TMPDIR/current.yaml" <<'YAML'
extraVolumes: |
  - name: google-service-account
    secret:
      secretName: google-service-account
extraVolumeMounts: |
  - name: google-service-account
    mountPath: /secrets/gcp-service-account.json
extraObjects:
  - "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: other"
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-brand
    data:
      brand.yaml: stale
YAML
  run "$SCRIPT" --render-only --codemie-values "$BATS_TEST_TMPDIR/current.yaml" --output-dir "$OUT/a" \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  f="$OUT/a/values-codemie.brand.yaml"
  [ "$(yq eval '.extraVolumes' "$f" | yq eval 'length' -)" = "2" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval 'length' -)" = "2" ]
  [ "$(yq eval '.extraObjects | length' "$f")" = "2" ]
  [ "$(yq eval '.extraObjects[0] | tag' "$f")" = "!!str" ]
  [ "$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .data."brand.yaml"' "$f" | grep -c stale)" = "0" ]
  # feeding the result back in changes nothing
  run "$SCRIPT" --render-only --codemie-values "$f" --output-dir "$OUT/b" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  diff "$f" "$OUT/b/values-codemie.brand.yaml"
}

@test "values files: YAML-special characters in package values are encoded, not injected" {
  pkg=$(mutate '.product.name = "Acme: Suite #1 *x* & '"'"'Co'"'"'" | .links.userGuide.name = "Docs: *all* & more"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.brand.product.name' "$OUT/values-codemie-ui.brand.yaml")" = "Acme: Suite #1 *x* & 'Co'" ]
  [ "$(yq eval '.extraObjects[0].data."brand.yaml"' "$OUT/values-codemie.brand.yaml" | yq eval '.links.userGuide.name' -)" = 'Docs: *all* & more' ]
}

@test "apply mode: calls helm upgrade with --reuse-values for both releases" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -q "helm upgrade my-ui repo/ui --reuse-values" "$BATS_TMPDIR/helm-calls"
  grep -q "helm upgrade my-backend repo/api --reuse-values" "$BATS_TMPDIR/helm-calls"
}

@test "apply mode: pins the installed chart version and never sets the image tag" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" --output-dir "$OUT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -q "helm upgrade my-ui repo/ui --reuse-values --version 1.2.3 " "$BATS_TMPDIR/helm-calls"
  grep -q "helm upgrade my-backend repo/api --reuse-values --version 1.2.3 " "$BATS_TMPDIR/helm-calls"
  run grep -E -- "--set|image" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
  [ "$(yq eval 'has("image")' "$OUT/values-codemie-ui.brand.yaml")" = "false" ]
  [ "$(yq eval 'has("image")' "$OUT/values-codemie.brand.yaml")" = "false" ]
}

@test "apply mode: merges the API release's current values read from the cluster" {
  cat >"$BATS_TEST_TMPDIR/current.yaml" <<'YAML'
extraVolumes: |
  - name: google-service-account
    secret:
      secretName: google-service-account
YAML
  run env PATH="$STUBS:$PATH" HELM_STUB_VALUES="$BATS_TEST_TMPDIR/current.yaml" \
    "$SCRIPT" --output-dir "$OUT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -q "helm get values my-backend .*--all" "$BATS_TMPDIR/helm-calls"
  [ "$(yq eval '.extraVolumes' "$OUT/values-codemie.brand.yaml" | yq eval 'length' -)" = "2" ]
}

@test "apply mode: calls kubectl rollout restart for both deployments" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -q "rollout restart deployment/my-ui" "$BATS_TMPDIR/kubectl-calls"
  grep -q "rollout restart deployment/my-backend" "$BATS_TMPDIR/kubectl-calls"
}

@test "apply mode: waits for both rollouts to finish" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  grep -q "rollout status deployment/my-ui" "$BATS_TMPDIR/kubectl-calls"
  grep -q "rollout status deployment/my-backend" "$BATS_TMPDIR/kubectl-calls"
}

@test "apply mode: chart references are required, and nothing runs without them" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" --release-ui my-ui --release-codemie my-backend \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--chart-ui is required"* ]]
  [ ! -f "$BATS_TMPDIR/helm-calls" ]
  [ ! -f "$BATS_TMPDIR/kubectl-calls" ]
}

@test "apply mode: validation failure stops before any helm or kubectl call" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$FIXTURES/missing-product.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [ ! -f "$BATS_TMPDIR/helm-calls" ]
  [ ! -f "$BATS_TMPDIR/kubectl-calls" ]
}

# ── email block ──────────────────────────────────────────────────────────────

# email_assets -> path of a writable copy of the asset fixtures plus the email logo fixtures
email_assets() {
  local d="$BATS_TEST_TMPDIR/email-assets"
  if [ ! -d "$d" ]; then
    cp -R "$ASSETS_DIR" "$d"
    cp "$FIXTURES"/email-assets/* "$d/"
  fi
  echo "$d"
}

# email_pkg '<yq expression>' -> valid.yaml with a logo.png email block and the change applied
email_pkg() {
  yq eval '.email = {"senderName": "Acme Notifications", "signature": "The {productName} Team", "palette": {"primary": "#112233"}, "images": {"logo": "logo.png"}, "messages": {"verification": {"subject": "Verify {productName}"}}} | '"$1" \
    "$FIXTURES/valid.yaml" >"$BATS_TEST_TMPDIR/email-mutated.yaml"
  echo "$BATS_TEST_TMPDIR/email-mutated.yaml"
}

# expect_email_error '<yq expression>' '<text expected in output>'
expect_email_error() {
  pkg=$(email_pkg "$1")
  run env PATH="$STUBS:$PATH" "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 1 ]
  grep -qF -- "$2" <<<"$output"
  [ ! -e "$OUT/brand.css" ]
  [ ! -f "$BATS_TMPDIR/helm-calls" ]
  [ ! -f "$BATS_TMPDIR/kubectl-calls" ]
}

@test "email: a valid email block passes" {
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
}

@test "email: a package without an email block still passes" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.extraObjects[0].data."brand.yaml"' "$OUT/values-codemie.brand.yaml" | yq eval 'has("email")' -)" = "false" ]
}

@test "email: a palette colour that is not #RRGGBB is rejected by the schema" {
  expect_email_error '.email.palette.primary = "red"' "palette/primary"
}

@test "email: an upper-case and lower-case hex palette is accepted" {
  pkg=$(email_pkg '.email.palette.primary = "#aabbcc" | .email.palette.text = "#AABBCC"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
}

@test "email: unknown keys are rejected at every level" {
  expect_email_error '.email.foo = "x"' "email"
  expect_email_error '.email.palette.accent = "#112233"' "palette"
  expect_email_error '.email.images.banner = "logo.png"' "images"
  expect_email_error '.email.messages.welcome.subject = "x"' "messages"
  expect_email_error '.email.messages.verification.title = "x"' "messages/verification"
}

@test "email: a field not allowed for the message id is rejected" {
  expect_email_error '.email.messages.budget_stopped.buttonLabel = "x"' "messages/budget_stopped"
}

@test "email: a blank senderName or subject is rejected" {
  expect_email_error '.email.senderName = "   "' "email.senderName"
  expect_email_error '.email.messages.password_reset.subject = ""' "email.messages.password_reset.subject"
}

@test "email: tokens not allowed for the field are rejected" {
  expect_email_error '.email.messages.verification.subject = "Hi {projectName}"' "email.messages.verification.subject"
  expect_email_error '.email.messages.budget_restored.intro = "Cost {costCenterName}"' "email.messages.budget_restored.intro"
  expect_email_error '.email.messages.budget_soft_limit.footer = "Hi {unknown}"' "{unknown}"
  expect_email_error '.email.signature = "Hi {projectName}"' "email.signature"
  expect_email_error '.email.senderName = "{costCenterName}"' "email.senderName"
}

@test "email: tokens are allowed where the backend allows them" {
  pkg=$(email_pkg '.email.messages.verification.footer = "{productName}" | .email.messages.budget_stopped.subject = "{productName} {projectName} {costCenterName}" | .email.messages.budget_stopped.intro = "{costCenterName} {projectName}" | .email.messages.budget_restored.subject = "{projectName}" | .email.messages.budget_restored.intro = "{projectName} {productName}" | .email.senderName = "{productName}"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
}

@test "email: strings that are not tokens under the backend regex are accepted" {
  # TOKEN_RE is \{(\w+)\}: {a b}, {} and {a-b} are not tokens
  pkg=$(email_pkg '.email.messages.verification.footer = "Use {a b}, {} or {a-b} freely"')
  run "$SCRIPT" --render-only --output-dir "$OUT/ok" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  # a token nested in doubled braces is still found, as in the backend
  expect_email_error '.email.messages.verification.footer = "{{unknown}}"' "{unknown}"
}

@test "email: logo names with a path, backslash or .. are rejected" {
  expect_email_error '.email.images.logo = "sub/logo.png"' "email.images.logo"
  expect_email_error '.email.images.logo = "sub\\logo.png"' "email.images.logo"
  expect_email_error '.email.images.logo = "..logo.png"' "email.images.logo"
}

@test "email: a logo with the wrong extension is rejected" {
  cp "$FIXTURES/email-assets/logo.png" "$(email_assets)/logo.svg"
  expect_email_error '.email.images.logo = "logo.svg"' "email.images.logo"
}

@test "email: a missing logo file is rejected" {
  expect_email_error '.email.images.logo = "absent.png"' "email.images.logo"
}

@test "email: a symlinked logo is rejected" {
  ln -s "$FIXTURES/email-assets/logo.png" "$(email_assets)/link.png"
  expect_email_error '.email.images.logo = "link.png"' "email.images.logo"
}

@test "email: a logo whose bytes do not match the extension is rejected" {
  expect_email_error '.email.images.logo = "bad-magic.png"' "email.images.logo"
  cp "$FIXTURES/email-assets/logo.png" "$(email_assets)/png-as.jpg"
  expect_email_error '.email.images.logo = "png-as.jpg"' "email.images.logo"
}

@test "email: a logo over 262144 bytes is rejected, exactly 262144 is accepted" {
  a="$(email_assets)"
  { cat "$FIXTURES/email-assets/logo.png"; head -c $((262145 - 70)) /dev/zero; } >"$a/big.png"
  [ "$(wc -c <"$a/big.png" | tr -d ' ')" -eq 262145 ]
  expect_email_error '.email.images.logo = "big.png"' "email.images.logo"
  { cat "$FIXTURES/email-assets/logo.png"; head -c $((262144 - 70)) /dev/zero; } >"$a/edge.png"
  pkg=$(email_pkg '.email.images.logo = "edge.png"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$a"
  [ "$status" -eq 0 ]
}

@test "email: valid logos of each type pass, extension case does not matter" {
  a="$(email_assets)"
  cp "$FIXTURES/email-assets/logo.png" "$a/LOGO.PNG"
  for name in logo.png logo.jpg logo.gif LOGO.PNG; do
    pkg=$(email_pkg ".email.images.logo = \"$name\"")
    run "$SCRIPT" --render-only --output-dir "$OUT/$name" "$pkg" "$a"
    [ "$status" -eq 0 ]
  done
  cp "$FIXTURES/email-assets/logo.jpg" "$a/photo.jpeg"
  pkg=$(email_pkg '.email.images.logo = "photo.jpeg"')
  run "$SCRIPT" --render-only --output-dir "$OUT/jpeg" "$pkg" "$a"
  [ "$status" -eq 0 ]
}

@test "email: every bad email field is listed at once, with no output and no helm or kubectl call" {
  pkg=$(email_pkg '.email.palette.primary = "red" | .email.senderName = "" | .email.messages.verification.subject = "{projectName}" | .email.images.logo = "bad-magic.png"')
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$pkg" "$(email_assets)"
  [ "$status" -eq 1 ]
  grep -qF -- "palette/primary" <<<"$output"
  grep -qF -- "email.senderName" <<<"$output"
  grep -qF -- "email.messages.verification.subject" <<<"$output"
  grep -qF -- "email.images.logo" <<<"$output"
  [ ! -f "$BATS_TMPDIR/helm-calls" ]
  [ ! -f "$BATS_TMPDIR/kubectl-calls" ]
}
