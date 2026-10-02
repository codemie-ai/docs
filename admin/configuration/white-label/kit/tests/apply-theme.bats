#!/usr/bin/env bats
# Prerequisites: yq >=4, ajv-cli >=6, bats-core >=1.10
SCHEMA="$BATS_TEST_DIRNAME/../theme-package.schema.json"
FIXTURES="$BATS_TEST_DIRNAME/fixtures"

@test "schema: empty object fails validation" {
  run bash -c "echo '{}' | ajv validate -s \"$SCHEMA\" --spec draft7 -"
  [ "$status" -ne 0 ]
}
