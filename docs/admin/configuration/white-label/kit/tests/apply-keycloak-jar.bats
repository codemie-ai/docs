#!/usr/bin/env bats
# Tests of the --jar option of apply-keycloak-theme: layout, manifest, content and determinism.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5, zip, unzip, bats-core >=1.10
bats_require_minimum_version 1.5.0
FIXTURES="$BATS_TEST_DIRNAME/fixtures"
SCRIPT="$BATS_TEST_DIRNAME/../apply-keycloak-theme"
ASSETS_DIR="$FIXTURES/assets"

setup() {
  OUT="$BATS_TEST_TMPDIR/theme-out"
  JAR="$BATS_TEST_TMPDIR/jars/theme.jar"
  PKG="$FIXTURES/keycloak.yaml"
}

EXPECTED_ENTRIES="META-INF/keycloak-themes.json
theme/acme-brand/email/theme.properties
theme/acme-brand/login/resources/css/brand.css
theme/acme-brand/login/resources/img/favicon.ico
theme/acme-brand/login/resources/img/favicon.svg
theme/acme-brand/login/resources/img/logo-dark.svg
theme/acme-brand/login/resources/img/logo-light.svg
theme/acme-brand/login/theme.properties"

@test "jar: lists exactly the manifest and the theme files, and nothing else" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --jar "$JAR" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ -f "$JAR" ]
  [ "$(unzip -Z1 "$JAR")" = "$EXPECTED_ENTRIES" ]
}

@test "jar: the manifest parses and holds the theme name and the types" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --jar "$JAR" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  unzip -p "$JAR" META-INF/keycloak-themes.json >"$BATS_TEST_TMPDIR/manifest.json"
  [ "$(yq eval -o=yaml '.themes | length' "$BATS_TEST_TMPDIR/manifest.json")" = "1" ]
  [ "$(yq eval -o=yaml '.themes[0].name' "$BATS_TEST_TMPDIR/manifest.json")" = "acme-brand" ]
  [ "$(yq eval -o=yaml '.themes[0].types | join(",")' "$BATS_TEST_TMPDIR/manifest.json")" = "login,email" ]
}

@test "jar: the file tree equals the owned files and a foreign file of the folder is absent" {
  mkdir -p "$OUT/login/resources"
  echo "custom" >"$OUT/login/resources/custom.js"
  echo "other" >"$OUT/notes.txt"
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --jar "$JAR" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ -f "$OUT/login/resources/custom.js" ]
  ! unzip -Z1 "$JAR" | grep -E 'custom|notes'
  mkdir "$BATS_TEST_TMPDIR/unpacked"
  unzip -q "$JAR" -d "$BATS_TEST_TMPDIR/unpacked"
  a=$(cd "$BATS_TEST_TMPDIR/unpacked/theme/acme-brand" && find . -type f | LC_ALL=C sort)
  b=$(cd "$OUT" && find . -type f ! -name custom.js ! -name notes.txt | LC_ALL=C sort)
  [ "$a" = "$b" ]
  while IFS= read -r f; do
    cmp "$BATS_TEST_TMPDIR/unpacked/theme/acme-brand/$f" "$OUT/$f"
  done <<<"$a"
}

@test "jar: two runs in two different TMPDIRs give equal bytes" {
  mkdir "$BATS_TEST_TMPDIR/t1" "$BATS_TEST_TMPDIR/t2"
  TMPDIR="$BATS_TEST_TMPDIR/t1" run --separate-stderr "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/o1" --jar "$BATS_TEST_TMPDIR/a.jar" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  sleep 2
  TMPDIR="$BATS_TEST_TMPDIR/t2" run --separate-stderr "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/o2" --jar "$BATS_TEST_TMPDIR/b.jar" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  cmp "$BATS_TEST_TMPDIR/a.jar" "$BATS_TEST_TMPDIR/b.jar"
}

@test "jar: equal bytes in two time zones and umasks, and the jar is readable by all" {
  TZ=Pacific/Auckland run --separate-stderr "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/o1" --jar "$BATS_TEST_TMPDIR/a.jar" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  (umask 077; TZ=America/Los_Angeles "$SCRIPT" --output-dir "$BATS_TEST_TMPDIR/o2" --jar "$BATS_TEST_TMPDIR/b.jar" "$PKG" "$ASSETS_DIR")
  cmp "$BATS_TEST_TMPDIR/a.jar" "$BATS_TEST_TMPDIR/b.jar"
  [ "$(stat -f %Lp "$BATS_TEST_TMPDIR/b.jar" 2>/dev/null || stat -c %a "$BATS_TEST_TMPDIR/b.jar")" = "644" ]
}

@test "jar: no jar without --jar" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ -z "$(find "$BATS_TEST_TMPDIR" -name '*.jar')" ]
  [[ "$stderr" != *"jar"* ]]
}

@test "jar: the written-target lines name the folder and the jar" {
  run --separate-stderr "$SCRIPT" --output-dir "$OUT" --jar "$JAR" "$PKG" "$ASSETS_DIR"
  [ "$status" -eq 0 ]
  [ "$(tail -n 2 <<<"$stderr" | head -n 1)" = "apply-keycloak-theme: written folder $OUT" ]
  [ "$(tail -n 1 <<<"$stderr")" = "apply-keycloak-theme: written jar $JAR" ]
}

@test "jar: a run with --jar and no zip on PATH fails before it writes anything" {
  bin="$BATS_TEST_TMPDIR/bin"
  mkdir "$bin"
  for tool in bash env yq ajv node mktemp dirname basename cp mv rm mkdir sort uniq touch find sed grep cat tr cut head tail wc ls printf date readlink pwd chmod ln test expr awk id uname; do
    p=$(command -v "$tool" 2>/dev/null) || continue
    [[ "$p" == /* ]] && ln -s "$p" "$bin/$tool"
  done
  PATH="$bin" run /bin/bash "$SCRIPT" --output-dir "$OUT" --jar "$JAR" "$PKG" "$ASSETS_DIR"
  [ "$status" -ne 0 ]
  [[ "$output" == *"zip is required for --jar"* ]]
  [ ! -e "$OUT" ]
  [ ! -e "$BATS_TEST_TMPDIR/jars" ]
}
