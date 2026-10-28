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

@test "brand.css: effects.gradients none writes the option into :root" {
  pkg=$(mutate '.effects.gradients = "none"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  root=$(sed -n '/^:root {/,/^}/p' "$OUT/brand.css")
  [[ "$root" == *"  --brand-gradients: none;"* ]]
  # the option is theme independent, so it is not in a theme block
  ! sed -n '/^html.codemie/,/^}/p' "$OUT/brand.css" | grep -q -- '--brand-gradients'
}

@test "brand.css: effects.gradients none makes two-colour gradients single-colour in both themes" {
  pkg=$(mutate '.effects.gradients = "none"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  for theme in codemieDark codemieLight; do
    block=$(sed -n "/^html.$theme {/,/^}/p" "$OUT/brand.css")
    for pair in border-specific-primary-button surface-specific-button-tertiary onboarding-tooltip \
      surface-specific-tint-gradient surface-specific-banner-gradient surface-specific-switch-on \
      surface-specific-magic-gradient surface-specific-action-accent-hover surface-specific-swatch-gradient; do
      [[ "$block" == *"--colors-$pair-to: var(--colors-$pair-from);"* ]]
    done
    [[ "$block" == *"--colors-surface-specific-swatch-gradient-via: var(--colors-surface-specific-swatch-gradient-from);"* ]]
  done
}

@test "brand.css: the single-colour rules come after the package colours, and only with gradients none" {
  pkg=$(mutate '.effects.gradients = "none" | .colors["border.specific.primary-button-to"] = {"dark": "#111111", "light": "#222222"}')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  block=$(sed -n '/^html.codemieDark {/,/^}/p' "$OUT/brand.css")
  first=$(grep -n -- '--colors-border-specific-primary-button-to: 17 17 17' <<<"$block" | cut -d: -f1)
  last=$(grep -n -- '--colors-border-specific-primary-button-to: var(' <<<"$block" | cut -d: -f1)
  [ "$first" -lt "$last" ]
  run "$SCRIPT" --render-only --output-dir "$BATS_TEST_TMPDIR/out3" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  ! grep -q -- 'primary-button-to: var(' "$BATS_TEST_TMPDIR/out3/brand.css"
}

@test "brand.css: no --brand-gradients without effects, or with effects.gradients default" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  ! grep -q -- '--brand-gradients' "$OUT/brand.css"
  pkg=$(mutate '.effects.gradients = "default"')
  run "$SCRIPT" --render-only --output-dir "$BATS_TEST_TMPDIR/out2" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  ! grep -q -- '--brand-gradients' "$BATS_TEST_TMPDIR/out2/brand.css"
}

@test "validate: effects.gradients accepts only default or none" {
  pkg=$(mutate '.effects.gradients = "hidden"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"gradients"* ]]
  [ ! -e "$OUT/brand.css" ]
}

@test "validate: an unknown key under effects is rejected" {
  pkg=$(mutate '.effects.shadows = "none"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"effects"* ]]
  [[ "$output" == *"additional properties"* ]]
}

@test "brand.css: side panel and gradient tokens map to the variables the UI reads" {
  # one token per line: path, dark, light. The names are the tokens listed in the Theme Package Reference.
  pkg=$(mutate '.colors."surface.base.navigation" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.specific.navigation-link" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.navigation-link" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.navigation-link-hover" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.navigation-icon" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.navigation-icon-hover" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.specific.navigation-badge" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.navigation-badge" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.specific.bottom-navigation-label" = {"dark": "#010203", "light": "#040506"}
    | .colors."text.specific.bottom-navigation-label" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.base.sidebar" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.specific.sidebar-toggle" = {"dark": "#010203", "light": "#040506"}
    | .colors."border.specific.sidebar" = {"dark": "#010203", "light": "#040506"}
    | .colors."surface.specific.gradient" = {"dark": "#010203", "light": "#040506"}')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  dark=$(sed -n '/^html.codemieDark {/,/^}/p' "$OUT/brand.css")
  light=$(sed -n '/^html.codemieLight {/,/^}/p' "$OUT/brand.css")
  for var in surface-base-navigation surface-specific-navigation-link text-specific-navigation-link \
    text-specific-navigation-link-hover text-specific-navigation-icon text-specific-navigation-icon-hover \
    surface-specific-navigation-badge text-specific-navigation-badge surface-specific-bottom-navigation-label \
    text-specific-bottom-navigation-label surface-base-sidebar surface-specific-sidebar-toggle \
    border-specific-sidebar surface-specific-gradient; do
    [[ "$dark" == *"  --colors-$var: 1 2 3;"* ]]
    [[ "$light" == *"  --colors-$var: 4 5 6;"* ]]
  done
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
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval '.[] | select(.name == "codemie-brand" and .subPath == "brand.yaml") | .mountPath' -)" = "/etc/codemie/brand.yaml" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval '.[] | select(.name == "codemie-brand" and .mountPath == "/etc/codemie/brand.yaml") | .subPath' -)" = "brand.yaml" ]
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
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval 'length' -)" = "3" ]
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

@test "email: logo names that break the asset name rule are rejected" {
  a="$(email_assets)"
  cp "$FIXTURES/email-assets/logo.png" "$a/my logo.png"
  cp "$FIXTURES/email-assets/logo.png" "$a/.png"
  cp "$FIXTURES/email-assets/logo.png" "$a/logo@2x.png"
  expect_email_error '.email.images.logo = "my logo.png"' "email.images.logo"
  expect_email_error '.email.images.logo = ".png"' "email.images.logo"
  expect_email_error '.email.images.logo = "logo@2x.png"' "email.images.logo"
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

# ── email rendering ──────────────────────────────────────────────────────────

# brand_yaml <values-codemie.brand.yaml> -> the ConfigMap's brand.yaml text
brand_yaml() { yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .data."brand.yaml"' "$1"; }

# b64_decode_file <base64 text> <out file>: GNU uses -d, older macOS -D
b64_decode_file() { printf '%s' "$1" | base64 -d >"$2" 2>/dev/null || printf '%s' "$1" | base64 -D >"$2"; }

@test "render email: brand.yaml carries identity, email block and links; logo is binaryData" {
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  by="$BATS_TEST_TMPDIR/brand.yaml"
  brand_yaml "$f" >"$by"
  [ "$(yq eval '.identity.productName' "$by")" = "Acme Suite" ]
  [ "$(yq eval '.email.senderName' "$by")" = "Acme Notifications" ]
  [ "$(yq eval '.email.signature' "$by")" = "The {productName} Team" ]
  [ "$(yq eval '.email.palette.primary' "$by")" = "#112233" ]
  [ "$(yq eval '.email.images.logo' "$by")" = "logo.png" ]
  [ "$(yq eval '.email.messages.verification.subject' "$by")" = "Verify {productName}" ]
  [ "$(yq eval '.links.userGuide.url' "$by")" = "https://docs.acme.example/" ]
  b64=$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .binaryData."logo.png"' "$f")
  b64_decode_file "$b64" "$BATS_TEST_TMPDIR/decoded.png"
  cmp "$BATS_TEST_TMPDIR/decoded.png" "$FIXTURES/email-assets/logo.png"
}

@test "render email: a package without an email block renders no email key and no binaryData" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  [ "$(brand_yaml "$f" | yq eval 'has("email")' -)" = "false" ]
  [ "$(brand_yaml "$f" | yq eval '.identity.productName' -)" = "Acme Suite" ]
  [ "$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | has("binaryData")' "$f")" = "false" ]
}

@test "render email: the same volume is mounted whole at the brand-assets directory" {
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  mounts=$(yq eval '.extraVolumeMounts' "$f")
  [ "$(yq eval 'length' - <<<"$mounts")" = "2" ]
  [ "$(yq eval '.[] | select(.mountPath == "/etc/codemie/brand.yaml") | .subPath' - <<<"$mounts")" = "brand.yaml" ]
  [ "$(yq eval '.[] | select(.mountPath == "/etc/codemie/brand-assets") | .name' - <<<"$mounts")" = "codemie-brand" ]
  [ "$(yq eval '.[] | select(.mountPath == "/etc/codemie/brand-assets") | .readOnly' - <<<"$mounts")" = "true" ]
  [ "$(yq eval '.[] | select(.mountPath == "/etc/codemie/brand-assets") | has("subPath")' - <<<"$mounts")" = "false" ]
  [ "$(yq eval '.extraVolumes' "$f" | yq eval 'length' -)" = "1" ]
}

@test "render email: slice-1 values with only the subPath mount gain the directory mount, and a re-run is identical" {
  cat >"$BATS_TEST_TMPDIR/slice1.yaml" <<'YAML'
extraVolumes: |
  - name: codemie-brand
    configMap:
      name: codemie-brand
extraVolumeMounts: |
  - name: codemie-brand
    mountPath: /etc/codemie/brand.yaml
    subPath: brand.yaml
    readOnly: true
YAML
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --codemie-values "$BATS_TEST_TMPDIR/slice1.yaml" --output-dir "$OUT/a" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  f="$OUT/a/values-codemie.brand.yaml"
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval 'length' -)" = "2" ]
  [ "$(yq eval '.extraVolumes' "$f" | yq eval 'length' -)" = "1" ]
  run "$SCRIPT" --render-only --codemie-values "$f" --output-dir "$OUT/b" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  diff -r "$OUT/a" "$OUT/b"
}

@test "render email: entries named codemie-brand-assets do not suppress the codemie-brand entries" {
  cat >"$BATS_TEST_TMPDIR/similar.yaml" <<'YAML'
extraVolumes: |
  - name: codemie-brand-assets
    configMap:
      name: codemie-brand-assets
extraVolumeMounts: |
  - name: codemie-brand-assets
    mountPath: /etc/codemie/other
YAML
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --codemie-values "$BATS_TEST_TMPDIR/similar.yaml" --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  [ "$(yq eval '.extraVolumes' "$f" | yq eval 'length' -)" = "2" ]
  [ "$(yq eval '.extraVolumes' "$f" | yq eval '[.[] | select(.name == "codemie-brand")] | length' -)" = "1" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval 'length' -)" = "3" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval '[.[] | select(.name == "codemie-brand")] | length' -)" = "2" ]
}

@test "render email: existing entries are found whatever the key order, quoting or comments" {
  cat >"$BATS_TEST_TMPDIR/odd.yaml" <<'YAML'
extraVolumes: |
  - configMap:
      name: codemie-brand
    name: "codemie-brand" # brand
extraVolumeMounts: |
  - mountPath: '/etc/codemie/brand.yaml' # file
    name: codemie-brand
    subPath: brand.yaml
  - mountPath: "/etc/codemie/brand-assets"
    name: codemie-brand
YAML
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --codemie-values "$BATS_TEST_TMPDIR/odd.yaml" --output-dir "$OUT" "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  [ "$(yq eval '.extraVolumes' "$f" | yq eval 'length' -)" = "1" ]
  [ "$(yq eval '.extraVolumeMounts' "$f" | yq eval 'length' -)" = "2" ]
}

@test "render email: a logo near the size limit renders intact" {
  a="$(email_assets)"
  { cat "$FIXTURES/email-assets/logo.png"; head -c $((262144 - 70)) /dev/zero; } >"$a/edge.png"
  pkg=$(email_pkg '.email.images.logo = "edge.png"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$a"
  [ "$status" -eq 0 ]
  b64=$(yq eval '.extraObjects[] | select(.metadata.name == "codemie-brand") | .binaryData."edge.png"' "$OUT/values-codemie.brand.yaml")
  b64_decode_file "$b64" "$BATS_TEST_TMPDIR/edge.out"
  cmp "$BATS_TEST_TMPDIR/edge.out" "$a/edge.png"
}

@test "render email: apply mode with an email package restarts the backend deployment" {
  pkg=$(email_pkg '.')
  run env PATH="$STUBS:$PATH" "$SCRIPT" $(apply_args) "$pkg" "$(email_assets)"
  [ "$status" -eq 0 ]
  grep -q "rollout restart deployment/my-backend" "$BATS_TMPDIR/kubectl-calls"
}

# ── email checksum ───────────────────────────────────────────────────────────

# sum_of <dir> -> checksum/brand of the API values rendered into <dir>
sum_of() { yq eval '.podAnnotations."checksum/brand"' "$1/values-codemie.brand.yaml"; }

@test "checksum email: same-name logo bytes change rolls the checksum, a no-op re-run keeps it" {
  a="$(email_assets)"
  pkg=$(email_pkg '.')
  run "$SCRIPT" --render-only --output-dir "$OUT/a" "$pkg" "$a"
  [ "$status" -eq 0 ]
  run "$SCRIPT" --render-only --output-dir "$OUT/same" "$pkg" "$a"
  [ "$status" -eq 0 ]
  [ "$(sum_of "$OUT/a")" = "$(sum_of "$OUT/same")" ]
  printf 'x' >>"$a/logo.png"
  run "$SCRIPT" --render-only --output-dir "$OUT/b" "$pkg" "$a"
  [ "$status" -eq 0 ]
  [ "$(sum_of "$OUT/a")" != "$(sum_of "$OUT/b")" ]
}

@test "checksum email: an email text change and a palette change roll the checksum" {
  a="$(email_assets)"
  run "$SCRIPT" --render-only --output-dir "$OUT/a" "$(email_pkg '.')" "$a"
  run "$SCRIPT" --render-only --output-dir "$OUT/text" "$(email_pkg '.email.senderName = "Other"')" "$a"
  run "$SCRIPT" --render-only --output-dir "$OUT/pal" "$(email_pkg '.email.palette.primary = "#445566"')" "$a"
  [ "$(sum_of "$OUT/a")" != "$(sum_of "$OUT/text")" ]
  [ "$(sum_of "$OUT/a")" != "$(sum_of "$OUT/pal")" ]
}

@test "checksum email: UI and API annotations stay equal, with and without an email block" {
  run "$SCRIPT" --render-only --output-dir "$OUT/e" "$(email_pkg '.')" "$(email_assets)"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.brand.podAnnotations."checksum/brand"' "$OUT/e/values-codemie-ui.brand.yaml")" = "$(sum_of "$OUT/e")" ]
  run "$SCRIPT" --render-only --output-dir "$OUT/n" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(yq eval '.brand.podAnnotations."checksum/brand"' "$OUT/n/values-codemie-ui.brand.yaml")" = "$(sum_of "$OUT/n")" ]
}

# ── template and acme example ────────────────────────────────────────────────

@test "example: acme renders an email block that satisfies the backend rules" {
  ex="$BATS_TEST_DIRNAME/../examples/acme"
  run "$SCRIPT" --render-only --output-dir "$OUT" "$ex/theme-package.yaml" "$ex/assets"
  [ "$status" -eq 0 ]
  f="$OUT/values-codemie.brand.yaml"
  by="$BATS_TEST_TMPDIR/brand.yaml"
  brand_yaml "$f" >"$by"
  for role in primary primaryText text background surface; do
    yq eval ".email.palette.$role" "$by" | grep -Eq '^#[0-9A-Fa-f]{6}$'
  done
  # every token in the rendered block is one the backend knows
  ! yq eval '.email | .. | select(tag == "!!str")' "$by" | grep -oE '\{[A-Za-z0-9_]+\}' | grep -vE '^\{(productName|projectName|costCenterName)\}$'
  logo=$(yq eval '.email.images.logo' "$by")
  [ -n "$logo" ] && [ "$logo" != "null" ]
  b64=$(yq eval ".extraObjects[] | select(.metadata.name == \"codemie-brand\") | .binaryData.\"$logo\"" "$f")
  b64_decode_file "$b64" "$BATS_TEST_TMPDIR/logo.bin"
  [ "$(od -An -tx1 -N8 "$BATS_TEST_TMPDIR/logo.bin" | tr -d ' \n')" = "89504e470d0a1a0a" ]
  [ "$(wc -c <"$BATS_TEST_TMPDIR/logo.bin" | tr -d ' ')" -le 262144 ]
}

@test "example: the empty template still fails validation" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$BATS_TEST_DIRNAME/../theme-package.yaml" "$ASSETS_DIR"
  [ "$status" -eq 1 ]
}

# ── contract drift ───────────────────────────────────────────────────────────

# contract_keys <file>: print the non-comment, non-empty lines of a contract fixture
contract_keys() {
  grep -vE '^[[:space:]]*(#|$)' "$1"
}

@test "contract: rendered keys, marker and cap equal the fixture lists exactly" {
  pkg=$(kcpkg '.email.images.logoUrl = "https://static.acme.example/logo.png" | .email.palette = {"primary":"#112233","primaryText":"#ffffff","text":"#000000","background":"#eeeeee","surface":"#dddddd"} | .email.signature = "Team {productName}"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  T="$OUT/values-keycloak.theme.yaml"; R="$OUT/values-oauth2-proxy.realm.yaml"
  {
    echo keycloakx.childTheme
    yq eval '.keycloakx.childTheme | keys | .[]' "$T" | sed 's/^/keycloakx.childTheme./'
    yq eval '.keycloakx.childTheme.data | keys | .[]' "$T"
    yq eval '.keycloakx.childTheme.binaryData | keys | .[]' "$T" | sed 's/^\(img\.\).*/\1/'
    yq eval '.. | select(tag != "!!map") | path | join(".")' "$R" | sed 's/^\(realm\.smtp\)\..*/\1/'
    sed -n 's/^KC_MARKER="\(.*\)"$/\1/p' "$SCRIPT"
    sed -n 's/^KC_MAX_BYTES=\([0-9]*\).*/\1/p' "$SCRIPT"
  } | sort -u >"$BATS_TEST_TMPDIR/actual-chart"
  contract_keys "$FIXTURES/contract/chart-values-keys.txt" | sort -u >"$BATS_TEST_TMPDIR/expected-chart"
  diff "$BATS_TEST_TMPDIR/expected-chart" "$BATS_TEST_TMPDIR/actual-chart"
  for f in login.theme.properties email.theme.properties; do
    yq eval ".keycloakx.childTheme.data.\"$f\"" "$T" | grep -v '^parent=' | grep . | cut -d= -f1
  done | sort -u >"$BATS_TEST_TMPDIR/actual-ui"
  contract_keys "$FIXTURES/contract/ui-brand-keys.txt" | sort -u >"$BATS_TEST_TMPDIR/expected-ui"
  diff "$BATS_TEST_TMPDIR/expected-ui" "$BATS_TEST_TMPDIR/actual-ui"
}

# kc_check '<yq expression>' -> runs ajv against keycloak.yaml with the change applied
kc_check() {
  yq eval "$1" "$FIXTURES/keycloak.yaml" -o=json >"$BATS_TEST_TMPDIR/kc.json"
  run ajv validate -s "$SCHEMA" --spec draft7 -d "$BATS_TEST_TMPDIR/kc.json"
}

@test "schema: keycloak block accepted" {
  kc_check '.'
  [ "$status" -eq 0 ]
}

@test "schema: literal smtp password rejected" {
  kc_check '.keycloak.smtp.auth.password = "hunter2"'
  [ "$status" -ne 0 ]
  kc_check '.keycloak.smtp.auth.password.value = "hunter2"'
  [ "$status" -ne 0 ]
}

@test "schema: logoUrl http rejected" {
  kc_check '.email.images.logoUrl = "http://static.acme.example/logo.png"'
  [ "$status" -ne 0 ]
  kc_check '.email.images.logoUrl = "https://static.acme.example/logo.png"'
  [ "$status" -eq 0 ]
}

@test "schema: unknown keycloak key rejected" {
  kc_check '.keycloak.extra = "x"'
  [ "$status" -ne 0 ]
  kc_check '.keycloak.smtp.extra = "x"'
  [ "$status" -ne 0 ]
}

@test "stub: per-release values with -o json" {
  mkdir -p "$BATS_TEST_TMPDIR/hs"
  printf 'global:\n  name: acme\n' >"$BATS_TEST_TMPDIR/hs/rel-a.yaml"
  run env PATH="$STUBS:$PATH" HELM_STUB_DIR="$BATS_TEST_TMPDIR/hs" helm get values rel-a -n ns -o json
  [ "$status" -eq 0 ]
  [ "$(echo "$output" | yq eval -p json '.global.name' -)" = "acme" ]
  run env PATH="$STUBS:$PATH" HELM_STUB_DIR="$BATS_TEST_TMPDIR/hs" helm get values rel-a -n ns
  [[ "$output" == *"name: acme"* ]]
  run env PATH="$STUBS:$PATH" HELM_STUB_DIR="$BATS_TEST_TMPDIR/hs" helm get values rel-none -o json
  [ "$output" = "{}" ]
  grep -q "helm get values rel-a -n ns -o json" "$BATS_TMPDIR/helm-calls"
}

@test "stub: upgrade fail switch" {
  run env PATH="$STUBS:$PATH" HELM_STUB_FAIL_RELEASE=rel-a helm upgrade rel-a repo/x
  [ "$status" -eq 1 ]
  run env PATH="$STUBS:$PATH" HELM_STUB_FAIL_RELEASE=rel-a helm upgrade rel-b repo/x
  [ "$status" -eq 0 ]
  grep -q "helm upgrade rel-a repo/x" "$BATS_TMPDIR/helm-calls"
}

# ── keycloak phase-1 validation ──────────────────────────────────────────────

# kcpkg '<yq expression>' -> path of a copy of keycloak.yaml with the change applied
kcpkg() {
  yq eval "$1" "$FIXTURES/keycloak.yaml" >"$BATS_TEST_TMPDIR/kc-mutated.yaml"
  echo "$BATS_TEST_TMPDIR/kc-mutated.yaml"
}

# kc_render '<yq expression>' [assets dir] -> render-only run of the changed keycloak package
kc_render() {
  pkg=$(kcpkg "$1")
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "${2:-$ASSETS_DIR}"
}

# expects a failed run that names <field> and wrote nothing
kc_rejected() {
  [ "$status" -ne 0 ]
  [[ "$output" == *"$1"* ]]
  [ ! -e "$OUT" ] || [ -z "$(ls -A "$OUT")" ]
}

@test "validate: keycloak package with no change passes" {
  kc_render '.'
  [ "$status" -eq 0 ]
}

@test "validate: dollar-brace in product.name rejected" {
  kc_render '.product.name = "Acme ${env} Suite"'
  kc_rejected "product.name"
}

@test "validate: dollar-brace in product.shortName and email.signature rejected" {
  kc_render '.product.shortName = "A${x}" | .email.signature = "Team ${x}"'
  kc_rejected "product.shortName"
  [[ "$output" == *"email.signature"* ]]
}

@test "validate: dollar-brace is allowed when the keycloak block is absent" {
  pkg=$(mutate '.product.name = "Acme ${env}"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
}

@test "validate: angle brackets, quote, backslash and control characters rejected by field" {
  kc_render '.product.name = "Acme <b>"'
  kc_rejected "product.name"
  kc_render '.product.name = "Acme \"x\""'
  kc_rejected "product.name"
  kc_render '.product.shortName = "A\\B"'
  kc_rejected "product.shortName"
  kc_render '.product.name = "Acme\tSuite"'
  kc_rejected "product.name"
  kc_render '.product.name = "Acme\nSuite"'
  kc_rejected "product.name"
}

@test "validate: newline is allowed in email.signature only" {
  kc_render '.email.signature = "Best,\n{productName} team"'
  [ "$status" -eq 0 ]
  rm -rf "$OUT"
  kc_render '.email.signature = "Best,\n\tteam"'
  kc_rejected "email.signature"
}

@test "validate: leading or trailing whitespace rejected" {
  kc_render '.product.name = " Acme"'
  kc_rejected "product.name"
  kc_render '.product.shortName = "Acme "'
  kc_rejected "product.shortName"
}

@test "validate: reserved theme names rejected" {
  for n in codemie base keycloak; do
    kc_render ".keycloak.themeName = \"$n\""
    kc_rejected "keycloak.themeName"
  done
}

@test "validate: theme name outside a-z0-9- rejected" {
  kc_render '.keycloak.themeName = "Acme_Brand"'
  kc_rejected "keycloak.themeName"
  kc_render '.keycloak.themeName = "ab"'
  kc_rejected "keycloak.themeName"
}

@test "validate: missing logoLight rejected naming assets.logoLight" {
  kc_render 'del(.assets.logoLight)'
  kc_rejected "assets.logoLight"
}

@test "validate: svg email logo url rejected" {
  kc_render '.email.images.logoUrl = "https://static.acme.example/logo.svg"'
  kc_rejected "email.images.logoUrl"
  kc_render '.email.images.logoUrl = "https://static.acme.example/logo.SVG?v=2"'
  kc_rejected "email.images.logoUrl"
}

@test "validate: svg email logo file rejected" {
  kc_render '.email.images.logo = "logo-light.svg"'
  kc_rejected "email.images.logo"
}

@test "validate: smtp host without from rejected" {
  kc_render 'del(.keycloak.smtp.from)'
  kc_rejected "keycloak.smtp.from"
  kc_render 'del(.keycloak.smtp.host)'
  kc_rejected "keycloak.smtp.host"
}

@test "validate: literal smtp password rejected, nothing written, value not echoed" {
  kc_render '.keycloak.smtp.auth.password = "hunter2-literal"'
  kc_rejected "keycloak.smtp.auth.password"
  [[ "$output" != *"hunter2-literal"* ]]
}

@test "validate: literal smtp username rejected, value not echoed" {
  kc_render '.keycloak.smtp.auth.username = "mailer-literal"'
  kc_rejected "keycloak.smtp.auth.username"
  [[ "$output" != *"mailer-literal"* ]]
}

@test "validate: smtp password with value key rejected" {
  kc_render '.keycloak.smtp.auth.password = {"value": "hunter2-literal"}'
  kc_rejected "keycloak.smtp.auth.password"
  [[ "$output" != *"hunter2-literal"* ]]
}

# kc_size_assets <target>: asset dir in which the four Keycloak assets plus the rendered brand.css
# add up to exactly <target> bytes (base64-expanded). Sets KC_ASSETS and KC_PKG (padding sits in a
# typography value, which no properties file receives).
kc_size_assets() {
  KC_ASSETS="$BATS_TEST_TMPDIR/size-assets"
  rm -rf "$KC_ASSETS"
  cp -R "$ASSETS_DIR" "$KC_ASSETS"
  : >"$KC_ASSETS/logo-light.svg"
  local fixed=0 f n css pad
  for f in logo-dark.svg favicon.ico favicon.svg; do
    n=$(wc -c <"$KC_ASSETS/$f")
    fixed=$((fixed + 4 * ((n + 2) / 3)))
  done
  # empty logoLight expands to 0; measure the css once
  "$SCRIPT" --render-only --output-dir "$BATS_TEST_TMPDIR/size-probe" "$(kcpkg '.')" "$KC_ASSETS" >/dev/null
  css=$(wc -c <"$BATS_TEST_TMPDIR/size-probe/brand.css" | tr -d ' ')
  # make the remainder divisible by 4 with trailing spaces in codeFamily
  pad=$(((fixed + css - $1) % 4))
  pad=$(((4 - (pad < 0 ? pad + 4 : pad)) % 4))
  KC_PKG=$(kcpkg ".typography.codeFamily = \"Fira Code, monospace$(printf '%*s' "$pad" '')\"")
  css=$((css + pad))
  n=$((($1 - fixed - css) / 4 * 3))
  head -c "$n" /dev/zero | tr '\0' 'x' >"$KC_ASSETS/logo-light.svg"
}

@test "validate: keycloak assets of exactly 400000 bytes pass" {
  kc_size_assets 400000
  run "$SCRIPT" --render-only --output-dir "$OUT" "$KC_PKG" "$KC_ASSETS"
  [ "$status" -eq 0 ]
}

@test "validate: keycloak assets above 400000 bytes rejected, error names the JAR alternative" {
  kc_size_assets 400004
  run "$SCRIPT" --render-only --output-dir "$OUT" "$KC_PKG" "$KC_ASSETS"
  [ "$status" -ne 0 ]
  [[ "$output" == *"400000"* ]]
  [[ "$output" == *"JAR"* ]]
  [ ! -e "$OUT" ]
}

@test "validate: keycloak assets above 300000 bytes warn" {
  kc_size_assets 350000
  run "$SCRIPT" --render-only --output-dir "$OUT" "$KC_PKG" "$KC_ASSETS"
  [ "$status" -eq 0 ]
  [[ "$output" == *"warning"*"300000"* ]]
}

@test "validate: keycloak assets of exactly 300000 bytes do not warn" {
  kc_size_assets 300000
  run "$SCRIPT" --render-only --output-dir "$OUT" "$KC_PKG" "$KC_ASSETS"
  [ "$status" -eq 0 ]
  [[ "$output" != *"300000"* ]]
}

@test "validate: size is not checked without the keycloak block" {
  kc_size_assets 450000
  pkg=$(mutate '.')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$KC_ASSETS"
  [ "$status" -eq 0 ]
}

@test "validate: email.senderName without smtp warns" {
  kc_render 'del(.keycloak.smtp) | .email.senderName = "Acme Mail"'
  [ "$status" -eq 0 ]
  [[ "$output" == *"warning"*"email.senderName"* ]]
}

@test "validate: email.senderName with a full smtp block does not warn" {
  kc_render '.email.senderName = "Acme Mail"'
  [ "$status" -eq 0 ]
  [[ "$output" != *"email.senderName"* ]]
}

@test "validate: email.images.logo without logoUrl warns" {
  mkdir -p "$BATS_TEST_TMPDIR/both"
  cp "$ASSETS_DIR"/* "$FIXTURES/email-assets/logo.png" "$BATS_TEST_TMPDIR/both/"
  kc_render '.email.images.logo = "logo.png"' "$BATS_TEST_TMPDIR/both"
  [ "$status" -eq 0 ]
  [[ "$output" == *"warning"*"logoUrl"* ]]
}

@test "validate: keycloak errors are collected together" {
  kc_render '.product.name = " Acme<"| .keycloak.themeName = "base" | del(.assets.logoLight)'
  kc_rejected "product.name"
  [[ "$output" == *"keycloak.themeName"* ]]
  [[ "$output" == *"assets.logoLight"* ]]
}

@test "validate: --no-keycloak skips the keycloak checks" {
  pkg=$(kcpkg '.product.name = "Acme ${env}"')
  run "$SCRIPT" --render-only --no-keycloak --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
}

@test "validate: apply mode with the keycloak block needs both keycloak charts" {
  pkg=$(kcpkg '.')
  run env PATH="$STUBS:$PATH" "$SCRIPT" --output-dir "$OUT" --chart-ui repo/ui --chart-codemie repo/api "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--chart-keycloak"* ]]
  [[ "$output" == *"--chart-proxy"* ]]
  [ ! -e "$OUT" ]
}

@test "validate: empty smtp map is accepted" {
  kc_render '.keycloak.smtp = {}'
  [ "$status" -eq 0 ]
}

@test "validate: themeName missing is rejected by schema and script" {
  kc_check 'del(.keycloak.themeName)'
  [ "$status" -ne 0 ]
  kc_render 'del(.keycloak.themeName)'
  kc_rejected "keycloak.themeName"
}

@test "validate: oversize assets are reported together with other errors" {
  kc_size_assets 400004
  pkg=$(kcpkg '.product.name = " Acme<"')
  run "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$KC_ASSETS"
  [ "$status" -ne 0 ]
  [[ "$output" == *"product.name"* ]]
  [[ "$output" == *"400000"* ]]
}

@test "render: ampersand in product name stays literal in signature and sender" {
  kc_files '.product.name = "R&D Suite" | .email.signature = "Team {productName}" | .email.senderName = "{productName} Mail"'
  props=$(yq eval '.keycloakx.childTheme.data."email.theme.properties"' "$THEME")
  [[ "$props" == *"brand.email.signature=Team R&D Suite"* ]]
  [ "$(yq eval '.realm.smtp.fromDisplayName' "$REALM")" = "R&D Suite Mail" ]
}

# ── render: keycloak value files ─────────────────────────────────────────────

# kc_files '<yq expression>': render the keycloak package with the change applied into $OUT
kc_files() {
  kc_render "${1:-.}"
  [ "$status" -eq 0 ]
  THEME="$OUT/values-keycloak.theme.yaml"
  REALM="$OUT/values-oauth2-proxy.realm.yaml"
}

# prop <file key> <property>: value of a key in a rendered properties file
prop() {
  yq eval ".keycloakx.childTheme.data.\"$1\"" "$THEME" | grep -m1 "^$2=" | cut -d= -f2-
}

KC_EMAIL=$'.email.palette.primary = "#112233" | .email.palette.text = "#223344" | .email.images.logoUrl = "https://cdn.acme.example/logo.png" | .email.signature = "Best,\nThe {productName} team é"'

@test "render: login.theme.properties has contract keys" {
  kc_files
  [ "$(yq eval '.keycloakx.childTheme.enabled' "$THEME")" = "true" ]
  [ "$(yq eval '.keycloakx.childTheme.name' "$THEME")" = "acme-brand" ]
  [ "$(prop login.theme.properties parent)" = "codemie" ]
  [ "$(prop login.theme.properties brand.version)" = "1" ]
  [ "$(prop login.theme.properties brand.product.name)" = "Acme Suite" ]
  [ "$(prop login.theme.properties brand.product.shortName)" = "Acme" ]
  [ "$(prop login.theme.properties brand.logo.light)" = "logo-light.svg" ]
  [ "$(prop login.theme.properties brand.logo.dark)" = "logo-dark.svg" ]
  [ "$(prop login.theme.properties brand.favicon)" = "favicon.ico" ]
  [ "$(prop login.theme.properties brand.faviconSvg)" = "favicon.svg" ]
}

@test "render: login.brand.css equals brand.css byte for byte" {
  kc_files
  # yq prints the scalar plus one newline of its own, so the data is the file when the first
  # wc -c bytes match and exactly one byte follows
  yq eval '.keycloakx.childTheme.data."login.brand.css"' "$THEME" >"$BATS_TEST_TMPDIR/css-from-yaml"
  size=$(wc -c <"$OUT/brand.css" | tr -d ' ')
  head -c "$size" "$BATS_TEST_TMPDIR/css-from-yaml" >"$BATS_TEST_TMPDIR/css-head"
  cmp "$BATS_TEST_TMPDIR/css-head" "$OUT/brand.css"
  [ "$(wc -c <"$BATS_TEST_TMPDIR/css-from-yaml" | tr -d ' ')" = "$((size + 1))" ]
}

@test "render: images are base64 in binaryData under img.<file>, text stays in data" {
  kc_files
  for f in logo-light.svg logo-dark.svg favicon.ico favicon.svg; do
    [ "$(yq eval ".keycloakx.childTheme.binaryData.\"img.$f\"" "$THEME")" = "$(base64 <"$ASSETS_DIR/$f" | tr -d '\n')" ]
  done
  [ "$(yq eval '.keycloakx.childTheme.data | keys | .[]' "$THEME" | sort | tr '\n' ' ')" = "email.theme.properties login.brand.css login.theme.properties " ]
  [ "$(yq eval '.keycloakx.childTheme.binaryData | keys | .[]' "$THEME" | grep -vc '^img\.')" = "0" ]
}

@test "render: the theme file never sets extraVolumes or extraVolumeMounts" {
  kc_files
  [ "$(yq eval '.. | select(tag == "!!map") | keys | .[]' "$THEME" "$REALM" | grep -c '^extraVolume')" = "0" ]
  ! grep -q "extraVolume" "$THEME"
}

@test "render: email.theme.properties has parent, version, name and the email keys" {
  kc_files "$KC_EMAIL"
  [ "$(prop email.theme.properties parent)" = "codemie" ]
  [ "$(prop email.theme.properties brand.version)" = "1" ]
  [ "$(prop email.theme.properties brand.product.name)" = "Acme Suite" ]
  [ "$(prop email.theme.properties brand.email.color.primary)" = "#112233" ]
  [ "$(prop email.theme.properties brand.email.color.text)" = "#223344" ]
  [ "$(prop email.theme.properties brand.email.logo)" = "https://cdn.acme.example/logo.png" ]
}

@test "render: unset email keys are absent from email.theme.properties" {
  kc_files "$KC_EMAIL"
  props=$(yq eval '.keycloakx.childTheme.data."email.theme.properties"' "$THEME")
  ! grep -q 'brand.email.color.primaryText' <<<"$props"
  ! grep -q 'brand.email.color.surface' <<<"$props"
  kc_files '.'
  props=$(yq eval '.keycloakx.childTheme.data."email.theme.properties"' "$THEME")
  ! grep -q 'brand.email' <<<"$props"
}

@test "render: signature gets the product name and a newline as backslash-n on one line" {
  kc_files "$KC_EMAIL"
  props=$(yq eval '.keycloakx.childTheme.data."email.theme.properties"' "$THEME")
  line=$(grep '^brand.email.signature=' <<<"$props")
  [ "$(grep -c '^brand.email.signature=' <<<"$props")" = "1" ]
  [[ "$line" == 'brand.email.signature=Best,\nThe Acme Suite team '* ]]
  [ "$(printf '%s\n' "$props" | wc -l | tr -d ' ')" = "$(printf '%s\n' "$props" | grep -c '=')" ]
}

@test "render: non-ASCII text is kept as valid UTF-8" {
  kc_files "$KC_EMAIL"
  yq eval '.keycloakx.childTheme.data."email.theme.properties"' "$THEME" >"$BATS_TEST_TMPDIR/email.properties"
  grep -q 'team é' "$BATS_TEST_TMPDIR/email.properties"
  iconv -f UTF-8 -t UTF-8 "$BATS_TEST_TMPDIR/email.properties" >/dev/null
  kc_files '.product.name = "Acme Süite"'
  [ "$(prop login.theme.properties brand.product.name)" = "Acme Süite" ]
}

@test "render: realm values have displayName, both themes and the smtp keys" {
  kc_files "$KC_EMAIL | .email.senderName = \"Acme Mail\""
  [ "$(yq eval '.realm.displayName' "$REALM")" = "Acme Suite" ]
  [ "$(yq eval '.realm.themes.loginTheme' "$REALM")" = "acme-brand" ]
  [ "$(yq eval '.realm.themes.emailTheme' "$REALM")" = "acme-brand" ]
  [ "$(yq eval '.realm.smtp.host' "$REALM")" = "smtp.acme.example" ]
  [ "$(yq eval '.realm.smtp.from' "$REALM")" = "no-reply@acme.example" ]
  [ "$(yq eval '.realm.smtp.port' "$REALM")" = "587" ]
  [ "$(yq eval '.realm.smtp.enableSSL' "$REALM")" = "false" ]
  [ "$(yq eval '.realm.smtp.enableStartTLS' "$REALM")" = "true" ]
  [ "$(yq eval '.realm.smtp.fromDisplayName' "$REALM")" = "Acme Mail" ]
  [ "$(yq eval '.realm.smtp.authentication.username.secretKeyRef.name' "$REALM")" = "acme-smtp" ]
  [ "$(yq eval '.realm.smtp.authentication.password.secretKeyRef.key' "$REALM")" = "password" ]
}

@test "render: realm smtp holds secret references only, never a literal" {
  kc_files
  [ "$(yq eval '.realm.smtp.authentication.password | keys | .[]' "$REALM")" = "secretKeyRef" ]
  [ "$(yq eval '.realm.smtp.authentication.username | keys | .[]' "$REALM")" = "secretKeyRef" ]
}

@test "render: unset smtp sub-keys are null in the realm file" {
  kc_files 'del(.keycloak.smtp.port) | del(.keycloak.smtp.ssl) | del(.keycloak.smtp.starttls) | del(.keycloak.smtp.auth)'
  for k in port enableSSL enableStartTLS fromDisplayName authentication.username authentication.password; do
    [ "$(yq eval ".realm.smtp.$k | tag" "$REALM")" = "!!null" ]
  done
  [ "$(yq eval '.realm.smtp.host' "$REALM")" = "smtp.acme.example" ]
}

@test "render: username without password nulls the password" {
  kc_files 'del(.keycloak.smtp.auth.password)'
  [ "$(yq eval '.realm.smtp.authentication.password | tag' "$REALM")" = "!!null" ]
  [ "$(yq eval '.realm.smtp.authentication.username | keys | .[]' "$REALM")" = "secretKeyRef" ]
}

@test "render: no smtp block writes no realm smtp key and sets no sender name" {
  kc_files 'del(.keycloak.smtp) | .email.senderName = "Acme Mail"'
  [ "$(yq eval '.realm | has("smtp")' "$REALM")" = "false" ]
  ! grep -q 'Acme Mail' "$REALM"
  [ "$(yq eval '.realm.themes.loginTheme' "$REALM")" = "acme-brand" ]
}

@test "render: a smtp map without host and from writes no realm smtp key" {
  kc_files '.keycloak.smtp = {"port": 25}'
  [ "$(yq eval '.realm | has("smtp")' "$REALM")" = "false" ]
}

@test "render: an explicit empty smtp map nulls every realm smtp key" {
  kc_files '.keycloak.smtp = {}'
  for k in host from port enableSSL enableStartTLS fromDisplayName authentication.username authentication.password; do
    [ "$(yq eval ".realm.smtp.$k | tag" "$REALM")" = "!!null" ]
  done
  [ "$(yq eval '.realm.themes.loginTheme' "$REALM")" = "acme-brand" ]
}

@test "render: without a keycloak block the output files equal today's" {
  run "$SCRIPT" --render-only --output-dir "$OUT" "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(ls "$OUT" | tr '\n' ' ')" = "brand.css values-codemie-ui.brand.yaml values-codemie.brand.yaml " ]
}

@test "render: --no-keycloak writes no keycloak files" {
  pkg=$(kcpkg '.')
  run "$SCRIPT" --render-only --no-keycloak --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ ! -e "$OUT/values-keycloak.theme.yaml" ]
  [ ! -e "$OUT/values-oauth2-proxy.realm.yaml" ]
}

@test "render: --render-only with the keycloak block makes no helm or kubectl call" {
  pkg=$(kcpkg '.')
  run env PATH="$STUBS:$PATH" "$SCRIPT" --render-only --output-dir "$OUT" "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ -f "$OUT/values-keycloak.theme.yaml" ]
  [ ! -e "$BATS_TMPDIR/helm-calls" ]
  [ ! -e "$BATS_TMPDIR/kubectl-calls" ]
}

# ── apply: keycloak and proxy releases ───────────────────────────────────────

kc_apply_args() {
  echo --release-ui my-ui --release-codemie my-backend --chart-ui repo/ui --chart-codemie repo/api \
    --chart-keycloak repo/kc --chart-proxy repo/proxy
}

# kc_stub_dir [extra yq expression for the stored keycloak values]: HELM_STUB_DIR with a
# keycloak release that carries the hook marker
kc_stub_dir() {
  HS="$BATS_TEST_TMPDIR/hs"
  mkdir -p "$HS"
  cat >"$HS/keycloak.yaml" <<'YAML'
keycloakx:
  extraVolumes: |
    - name: keycloak-child-theme
      configMap:
        name: keycloak-child-theme
  extraVolumeMounts: |
    - name: keycloak-child-theme
      mountPath: /opt/keycloak/themes/acme-brand
YAML
  yq eval -i "${1:-.}" "$HS/keycloak.yaml"
}

# kc_apply [more args]: apply run of the keycloak package
kc_apply() {
  pkg=$(kcpkg '.')
  run env PATH="$STUBS:$PATH" HELM_STUB_DIR="$HS" ${KC_ENV:-} "$SCRIPT" --output-dir "$OUT" $(kc_apply_args) "$@" "$pkg" "$ASSETS_DIR"
}

@test "apply: keycloak upgrade runs before proxy with wait" {
  kc_stub_dir
  kc_apply
  [ "$status" -eq 0 ]
  ui=$(grep -n "^helm upgrade my-ui " "$BATS_TMPDIR/helm-calls" | cut -d: -f1)
  api=$(grep -n "^helm upgrade my-backend " "$BATS_TMPDIR/helm-calls" | cut -d: -f1)
  kc=$(grep -n "^helm upgrade keycloak " "$BATS_TMPDIR/helm-calls" | cut -d: -f1)
  px=$(grep -n "^helm upgrade oauth2-proxy " "$BATS_TMPDIR/helm-calls" | cut -d: -f1)
  [ "$ui" -lt "$api" ]
  [ "$api" -lt "$kc" ]
  [ "$kc" -lt "$px" ]
  grep -q "^helm upgrade keycloak repo/kc --reuse-values --version 1.2.3 -f $OUT/values-keycloak.theme.yaml -f $OUT/values-keycloak.stale.yaml -n security --wait --timeout 10m$" "$BATS_TMPDIR/helm-calls"
  grep -q "^helm upgrade oauth2-proxy repo/proxy --reuse-values --version 1.2.3 -f $OUT/values-oauth2-proxy.realm.yaml -n oauth2-proxy$" "$BATS_TMPDIR/helm-calls"
}

@test "apply: keycloak releases use their own names and namespaces, not --namespace" {
  kc_stub_dir
  mkdir -p "$HS"; cp "$HS/keycloak.yaml" "$HS/kc2.yaml"
  kc_apply --namespace apps --release-keycloak kc2 --release-proxy px2 \
    --namespace-keycloak sec2 --namespace-proxy px-ns --keycloak-timeout 3m
  [ "$status" -eq 0 ]
  grep -q "^helm upgrade my-ui .* -n apps$" "$BATS_TMPDIR/helm-calls"
  grep -q "^helm upgrade kc2 repo/kc .* -n sec2 --wait --timeout 3m$" "$BATS_TMPDIR/helm-calls"
  grep -q "^helm upgrade px2 repo/proxy .* -n px-ns$" "$BATS_TMPDIR/helm-calls"
  grep -q "^helm get values kc2 -n sec2 --all -o json" "$BATS_TMPDIR/helm-calls"
  run grep -E "(kc2|px2|keycloak|oauth2-proxy).* -n apps" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}

@test "apply: no kubectl rollout for keycloak or the proxy" {
  kc_stub_dir
  kc_apply
  [ "$status" -eq 0 ]
  run grep -E "keycloak|oauth2-proxy" "$BATS_TMPDIR/kubectl-calls"
  [ "$status" -ne 0 ]
}

@test "apply: keycloak upgrades set no value and change no image or chart version" {
  kc_stub_dir
  kc_apply
  [ "$status" -eq 0 ]
  run grep -E -- "--set|image" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}

@test "apply: no keycloak block, helm calls equal today's" {
  run env PATH="$STUBS:$PATH" "$SCRIPT" --output-dir "$OUT" $(apply_args) "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(grep -c '' "$BATS_TMPDIR/helm-calls")" = "5" ]
  run grep -E "keycloak|oauth2-proxy" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
  [ ! -e "$OUT/values-keycloak.stale.yaml" ]
}

@test "apply: --no-keycloak skips preflight, files and upgrades" {
  pkg=$(kcpkg '.')
  run env PATH="$STUBS:$PATH" "$SCRIPT" --output-dir "$OUT" --no-keycloak $(apply_args) "$pkg" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  run grep -E "keycloak|oauth2-proxy" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
  [ ! -e "$OUT/values-keycloak.stale.yaml" ]
}

@test "apply: missing keycloak chart flags fail before any helm call" {
  pkg=$(kcpkg '.')
  run env PATH="$STUBS:$PATH" "$SCRIPT" --output-dir "$OUT" $(apply_args) --chart-keycloak repo/kc "$pkg" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--chart-proxy"* ]]
  [ ! -e "$BATS_TMPDIR/helm-calls" ]
}

@test "apply: preflight fails when the hook is missing in extraVolumes" {
  kc_stub_dir 'del(.keycloakx.extraVolumes)'
  kc_apply
  [ "$status" -ne 0 ]
  [[ "$output" == *"extraVolumes"* ]]
  [[ "$output" == *"normal chart deploy"* ]]
  run grep "helm upgrade" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
  [ ! -e "$BATS_TMPDIR/kubectl-calls" ]
}

@test "apply: preflight fails when the hook is missing in extraVolumeMounts" {
  kc_stub_dir 'del(.keycloakx.extraVolumeMounts)'
  kc_apply
  [ "$status" -ne 0 ]
  [[ "$output" == *"extraVolumeMounts"* ]]
  [[ "$output" == *"normal chart deploy"* ]]
  run grep "helm upgrade" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}

@test "apply: keycloak release not deployed aborts before any upgrade" {
  HS="$BATS_TEST_TMPDIR/hs"; mkdir -p "$HS"
  kc_apply
  [ "$status" -ne 0 ]
  run grep "helm upgrade" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}

@test "apply: stored image keys missing from the new package are nulled in the stale file" {
  kc_stub_dir '.keycloakx.childTheme.binaryData."img.old-logo.png" = "QQ==" | .keycloakx.childTheme.data."login.theme.properties" = "x" | .keycloakx.childTheme.binaryData."img.logo-dark.svg" = "QQ=="'
  kc_apply
  [ "$status" -eq 0 ]
  stale="$OUT/values-keycloak.stale.yaml"
  [ "$(yq eval '.keycloakx.childTheme.binaryData."img.old-logo.png" | tag' "$stale")" = "!!null" ]
  [ "$(yq eval '.keycloakx.childTheme.binaryData | has("img.old-logo.png")' "$stale")" = "true" ]
  [ "$(yq eval '.keycloakx.childTheme.binaryData | length' "$stale")" = "1" ]
  [ "$(yq eval '.keycloakx.childTheme | has("data")' "$stale")" = "false" ]
  run grep -c ": null" "$OUT/values-keycloak.theme.yaml"
  [ "$output" = "0" ]
}

@test "apply: stale file is empty of keys when nothing was removed" {
  kc_stub_dir
  kc_apply
  [ "$status" -eq 0 ]
  [ "$(yq eval '.keycloakx.childTheme.binaryData | length' "$OUT/values-keycloak.stale.yaml")" = "0" ]
}

@test "apply: a failed keycloak upgrade skips the proxy upgrade" {
  kc_stub_dir
  KC_ENV="HELM_STUB_FAIL_RELEASE=keycloak" kc_apply
  [ "$status" -ne 0 ]
  grep -q "^helm upgrade keycloak " "$BATS_TMPDIR/helm-calls"
  run grep "^helm upgrade oauth2-proxy " "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}

@test "render-only: no stale file is written" {
  kc_files
  [ ! -e "$OUT/values-keycloak.stale.yaml" ]
}

@test "apply: unreadable proxy release stops before any upgrade" {
  kc_stub_dir
  KC_ENV="HELM_STUB_FAIL_METADATA=oauth2-proxy" kc_apply
  [ "$status" -ne 0 ]
  [[ "$output" == *"oauth2-proxy"* ]]
  run grep "helm upgrade" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
  [ ! -e "$BATS_TMPDIR/kubectl-calls" ]
}

@test "apply: non-map stored childTheme does not abort the stale scan" {
  kc_stub_dir '.keycloakx.childTheme = null'
  kc_apply
  [ "$status" -eq 0 ]
  kc_stub_dir '.keycloakx.childTheme.data = "text" | .keycloakx.childTheme.binaryData = null'
  kc_apply
  [ "$status" -eq 0 ]
}

@test "apply: stale data keys are nulled too" {
  kc_stub_dir '.keycloakx.childTheme.data."old.properties" = "x"'
  kc_apply
  [ "$status" -eq 0 ]
  [ "$(yq eval '.keycloakx.childTheme.data."old.properties" | tag' "$OUT/values-keycloak.stale.yaml")" = "!!null" ]
}

# ── example workflow ─────────────────────────────────────────────────────────

WORKFLOW="$BATS_TEST_DIRNAME/../.github/workflows/apply-theme.yml"

# wf_run <job> <step name> [VAR=value ...]: runs the shell script of one workflow step the way a
# GitHub runner does (bash -e) from a checkout that holds the kit under ./kit and the acme example
wf_run() {
  local script
  script=$(yq eval ".jobs.$1.steps[] | select(.name == \"$2\") | .run" "$WORKFLOW")
  [ -n "$script" ]
  [ "$script" != "null" ]
  shift 2
  mkdir -p "$BATS_TEST_TMPDIR/repo" "$BATS_TEST_TMPDIR/runner"
  ln -sfn "$BATS_TEST_DIRNAME/.." "$BATS_TEST_TMPDIR/repo/kit"
  cd "$BATS_TEST_TMPDIR/repo"
  run env PATH="$STUBS:$PATH" RUNNER_TEMP="$BATS_TEST_TMPDIR/runner" \
    PACKAGE_PATH=kit/examples/acme/theme-package.yaml ASSETS_PATH=kit/examples/acme/assets \
    NAMESPACE=apps RELEASE_UI=codemie-ui RELEASE_CODEMIE=codemie CHART_UI=repo/ui CHART_CODEMIE=repo/api \
    "$@" bash -e -c "$script"
}

@test "workflow: dispatch inputs cover the keycloak and proxy releases and an optional customer config" {
  for i in chart_keycloak chart_proxy no_keycloak release_keycloak release_proxy namespace_keycloak namespace_proxy customer_config_path; do
    [ "$(yq eval ".on.workflow_dispatch.inputs | has(\"$i\")" "$WORKFLOW")" = "true" ]
  done
  [ "$(yq eval '.on.workflow_dispatch.inputs.no_keycloak.type' "$WORKFLOW")" = "boolean" ]
  [ "$(yq eval '.on.workflow_dispatch.inputs.chart_keycloak.required' "$WORKFLOW")" != "true" ]
}

@test "workflow: validate stops early when a keycloak package has no keycloak chart" {
  wf_run validate "Check Keycloak inputs" CHART_KEYCLOAK= CHART_PROXY= NO_KEYCLOAK=false
  [ "$status" -ne 0 ]
  [[ "$output" == *"chart_keycloak"* ]]
  wf_run validate "Check Keycloak inputs" CHART_KEYCLOAK=repo/kc CHART_PROXY= NO_KEYCLOAK=false
  [ "$status" -ne 0 ]
  [[ "$output" == *"chart_proxy"* ]]
}

@test "workflow: validate accepts a keycloak package with both charts or with no_keycloak" {
  wf_run validate "Check Keycloak inputs" CHART_KEYCLOAK=repo/kc CHART_PROXY=repo/proxy NO_KEYCLOAK=false
  [ "$status" -eq 0 ]
  wf_run validate "Check Keycloak inputs" CHART_KEYCLOAK= CHART_PROXY= NO_KEYCLOAK=true
  [ "$status" -eq 0 ]
}

@test "workflow: validate passes a given customer config to the render step" {
  wf_run validate "Render theme package without touching the cluster" NO_KEYCLOAK=false \
    CUSTOMER_CONFIG_FILE="$BATS_TEST_TMPDIR/absent.yaml"
  [ "$status" -ne 0 ]
  [[ "$output" == *"customer config not found"* ]]
}

@test "workflow: validate render of the acme example succeeds" {
  wf_run validate "Render theme package without touching the cluster" NO_KEYCLOAK=false CUSTOMER_CONFIG_FILE=
  [ "$status" -eq 0 ]
  [ -f "$BATS_TEST_TMPDIR/repo/rendered/values-oauth2-proxy.realm.yaml" ]
}

@test "workflow: apply step applies the acme example including keycloak and the proxy" {
  kc_stub_dir
  mkdir -p "$BATS_TEST_TMPDIR/runner"
  cp "$FIXTURES/customer-config.yaml" "$BATS_TEST_TMPDIR/runner/customer-config.yaml"
  wf_run apply "Apply theme package" HELM_STUB_DIR="$HS" CHART_KEYCLOAK=repo/kc CHART_PROXY=repo/proxy NO_KEYCLOAK=false \
    RELEASE_KEYCLOAK=keycloak RELEASE_PROXY=oauth2-proxy NAMESPACE_KEYCLOAK=security NAMESPACE_PROXY=oauth2-proxy
  [ "$status" -eq 0 ]
  grep -q "^helm upgrade keycloak repo/kc " "$BATS_TMPDIR/helm-calls"
  grep -q "^helm upgrade oauth2-proxy repo/proxy " "$BATS_TMPDIR/helm-calls"
}

@test "workflow: apply step with no_keycloak skips the keycloak releases" {
  mkdir -p "$BATS_TEST_TMPDIR/runner"
  cp "$FIXTURES/customer-config.yaml" "$BATS_TEST_TMPDIR/runner/customer-config.yaml"
  wf_run apply "Apply theme package" CHART_KEYCLOAK= CHART_PROXY= NO_KEYCLOAK=true \
    RELEASE_KEYCLOAK=keycloak RELEASE_PROXY=oauth2-proxy NAMESPACE_KEYCLOAK=security NAMESPACE_PROXY=oauth2-proxy
  [ "$status" -eq 0 ]
  run grep "helm upgrade keycloak" "$BATS_TMPDIR/helm-calls"
  [ "$status" -ne 0 ]
}
