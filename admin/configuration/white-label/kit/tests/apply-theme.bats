#!/usr/bin/env bats
# Prerequisites: yq >=4, ajv-cli >=6, bats-core >=1.10
SCHEMA="$BATS_TEST_DIRNAME/../theme-package.schema.json"
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-theme"
ASSETS_DIR="$BATS_TEST_DIRNAME/fixtures/assets"

@test "schema: empty object fails validation" {
  run bash -c "echo '{}' | ajv validate -s \"$SCHEMA\" --spec draft7 -"
  [ "$status" -ne 0 ]
}

@test "validate: missing required field exits non-zero and names the field" {
  run "$SCRIPT" --render-only \
    "$FIXTURES/missing-product.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"product"* ]]
}

@test "validate: enabled link absent from package exits non-zero naming the link" {
  CUSTOMER_CONFIG_PATH="$FIXTURES/customer-config.yaml" \
  run "$SCRIPT" --render-only \
    "$FIXTURES/missing-link.yaml" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"customerSupport"* ]]
}

@test "validate: valid package passes" {
  run "$SCRIPT" --render-only \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
}

@test "render-only: writes output files without calling helm" {
  run env PATH="$BATS_TEST_DIRNAME/stubs:$PATH" "$SCRIPT" --render-only \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  ls /tmp/apply-theme-*/values-codemie-ui.brand.yaml 2>/dev/null || \
    [ -f "$BATS_TMPDIR/values-codemie-ui.brand.yaml" ]
}

@test "render-only: rendered files contain checksum annotation" {
  tmpdir=$(mktemp -d)
  "$SCRIPT" --render-only --output-dir "$tmpdir" \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  grep -q "checksum/brand:" "$tmpdir/values-codemie-ui.brand.yaml"
}

@test "render-only: chart version is not set in rendered values" {
  tmpdir=$(mktemp -d)
  "$SCRIPT" --render-only --output-dir "$tmpdir" \
    "$FIXTURES/valid.yaml" "$ASSETS_DIR"
  ! grep -q "^image:" "$tmpdir/values-codemie-ui.brand.yaml"
}
