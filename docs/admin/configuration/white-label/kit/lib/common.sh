# Shared functions of apply-theme and apply-keycloak-theme. Source this file; do not run it.
# Prerequisites: yq >=4 (mikefarah), ajv-cli >=5. Works with bash 3.2 and later.
#
# The caller sets KIT_SCRIPT (script name for messages) and SOURCE_DIR. Functions that read a
# package take its path as an argument; none of them reads a package through a global.
# Order of work of every script (the output changes only in the last step):
#   1. kit_removed_tokens   2. kit_check_inputs   3. build every target in a staged folder
#   4. kit_swap_file / kit_swap_dir
# bash 5.2 expands & in a replacement string; product names such as R&D must stay literal
shopt -u patsub_replacement 2>/dev/null || true

KIT_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Asset and logo file names. The same rule as the chart (keycloak-helm/templates/child-theme-configmap.yaml)
# and the UI (codemie-ui/src/utils/brand.ts). Held once here; the contract fixture holds the second copy.
KIT_ASSET_NAME_RE='^[A-Za-z0-9][A-Za-z0-9._-]{0,99}$'
KIT_ASSET_KEYS=(logoLight logoDark favicon faviconSvg manifest)
KIT_RESERVED_THEMES=(codemie codemie-default base keycloak)

KIT_STAGES=()
TMP_ROOT=""

kit_cleanup() {
  local s
  for s in ${KIT_STAGES[@]+"${KIT_STAGES[@]}"}; do rm -rf "$s"; done
  [[ -z "$TMP_ROOT" ]] || rm -rf "$TMP_ROOT"
}

# Scratch files live in one folder that is removed on exit. The schema input needs a .json
# extension, which ajv-cli uses to decide how to read it.
kit_init() {
  TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/kit-scratch-XXXXXX")
  trap kit_cleanup EXIT
}

kit_die() {
  echo "${KIT_SCRIPT:-kit}: $*" >&2
  exit 1
}

# kit_usage: print the synopsis of the running script and exit 1. A script with more options
# defines its own kit_usage after sourcing this file.
kit_usage() {
  echo "Usage: $KIT_SCRIPT [--output-dir <assets-folder>]" >&2
  echo "         <theme-package.yaml> <source-dir>" >&2
  echo "" >&2
  echo "  --output-dir  assets folder of the wrapper chart (default: ${KIT_DEFAULT_OUTPUT_DIR:-codemie-ui/assets})" >&2
  echo "  <source-dir>  folder with the logo, favicon, manifest and email logo files" >&2
  echo "Run the script from the root of the charts repository. Options go before the two arguments." >&2
  exit 1
}

# kit_parse_args <default output dir> "$@": sets OUTPUT_DIR, PACKAGE_FILE and SOURCE_DIR
kit_parse_args() {
  OUTPUT_DIR="$1"
  KIT_DEFAULT_OUTPUT_DIR="$1"
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --output-dir)
        [[ $# -ge 2 ]] || kit_die "--output-dir needs a value"
        OUTPUT_DIR="$2"
        shift 2
        ;;
      --help | -h) kit_usage ;;
      -*)
        echo "Unknown option: $1" >&2
        kit_usage
        ;;
      *) break ;;
    esac
  done
  [[ $# -ge 2 ]] || kit_usage
  if [[ $# -gt 2 ]]; then
    echo "Unexpected arguments after <source-dir>: ${*:3}" >&2
    echo "Options go before <theme-package.yaml> <source-dir>." >&2
    kit_usage
  fi
  PACKAGE_FILE="$1"
  SOURCE_DIR="$2"
}

# kit_str <package> <yq path>: the value when it is a string, else nothing
kit_str() { yq eval "$2 | select(tag == \"!!str\")" "$1" 2>/dev/null || true; }

# Render brand.css to stdout. Each token carries a dark and a light value, and both are emitted together:
# the dark values under html.codemieDark and the light values under html.codemieLight, the same
# selectors the built-in stylesheet uses, so the brand follows the user's theme switch. Values are
# space-separated "r g b" channels read through rgb(var(...)). Fonts are theme-independent and stay
# in :root. Nothing needs !important. Colours are always rendered; typography and effects only when
# the package has them.
kit_render_brand_css() { # <package>
  local pkg="$1" FONT_FACE GRADIENTS DARK_VARS="" LIGHT_VARS="" FLAT_VARS="" token dark light pair
  FONT_FACE=$(yq eval '.typography.fontFaceCSS // ""' "$pkg")
  GRADIENTS=$(yq eval '.effects.gradients // "default"' "$pkg")
  # effects.gradients: none also makes the two-colour gradients of controls and tinted areas single-colour: the
  # end colour follows the start colour (a var() reference, so it works whether or not the package sets the
  # start colour). The swatch gradient has a middle colour too.
  for pair in border-specific-primary-button surface-specific-button-tertiary onboarding-tooltip \
    surface-specific-tint-gradient surface-specific-banner-gradient surface-specific-switch-on \
    surface-specific-magic-gradient surface-specific-action-accent-hover surface-specific-swatch-gradient; do
    FLAT_VARS+="  --colors-${pair}-to: var(--colors-${pair}-from);"$'\n'
  done
  FLAT_VARS+="  --colors-surface-specific-swatch-gradient-via: var(--colors-surface-specific-swatch-gradient-from);"$'\n'
  _kit_hex_to_rgb() { printf '%d %d %d' "0x${1:1:2}" "0x${1:3:2}" "0x${1:5:2}"; }
  while read -r token dark light; do
    [[ -n "$token" ]] || continue
    DARK_VARS+="  --colors-${token//./-}: $(_kit_hex_to_rgb "$dark");"$'\n'
    LIGHT_VARS+="  --colors-${token//./-}: $(_kit_hex_to_rgb "$light");"$'\n'
  done < <(yq eval '.colors // {} | to_entries | .[] | .key + " " + .value.dark + " " + .value.light' "$pkg")

  {
    if [[ -n "$FONT_FACE" ]]; then echo "$FONT_FACE"; fi
    echo ":root {"
    if [[ "$(yq eval '.typography | tag' "$pkg")" != "!!null" ]]; then
      echo "  --font-family-body: $(yq eval '.typography.bodyFamily' "$pkg");"
      echo "  --font-family-body-prose: $(yq eval '.typography.bodyProseFamily' "$pkg");"
      echo "  --font-family-code-block: $(yq eval '.typography.codeFamily' "$pkg");"
    fi
    # effects.gradients: none removes every background gradient. The UI reads this variable; it is not a colour.
    if [[ "$GRADIENTS" == "none" ]]; then echo "  --brand-gradients: none;"; fi
    echo "}"
    if [[ -n "$DARK_VARS" || "$GRADIENTS" == "none" ]]; then
      echo "html.codemieDark {"
      printf '%s' "$DARK_VARS"
      if [[ "$GRADIENTS" == "none" ]]; then printf '%s' "$FLAT_VARS"; fi
      echo "}"
      echo "html.codemieLight {"
      printf '%s' "$LIGHT_VARS"
      if [[ "$GRADIENTS" == "none" ]]; then printf '%s' "$FLAT_VARS"; fi
      echo "}"
    fi
  }
}

# Removed tokens (step 1). Each one found is named with the text to set it in the realm settings.
kit_removed_tokens() { # <package>
  local pkg="$1" found=0
  if [[ "$(yq eval '.email.senderName | tag' "$pkg" 2>/dev/null || echo '!!null')" != "!!null" ]]; then
    echo "$KIT_SCRIPT: email.senderName is removed from the theme package." >&2
    echo "  The sender name of platform emails comes from EMAIL_FROM_NAME in the API values (default: Platform Notifications)." >&2
    echo "  Set the sender name of Keycloak emails in the Keycloak realm settings (Email, From display name)." >&2
    found=1
  fi
  if [[ "$(yq eval '.keycloak | tag' "$pkg" 2>/dev/null || echo '!!null')" != "!!null" ]]; then
    echo "$KIT_SCRIPT: the keycloak block moved to keycloak-theme-package.yaml." >&2
    echo "  Remove the block from this package and put the theme name in keycloak-theme-package.yaml (run apply-keycloak-theme with it)." >&2
    if [[ "$(yq eval '.keycloak.smtp | tag' "$pkg" 2>/dev/null || echo '!!null')" != "!!null" ]]; then
      echo "  keycloak.smtp is removed: set the SMTP server of Keycloak in the Keycloak realm settings (Email)." >&2
    fi
    found=1
  fi
  [[ "$found" == "0" ]]
}

# Properties policy: every value that reaches a .properties file. Rejects ${, < > " \, control
# characters (a newline only when allowed) and leading or trailing whitespace.
_kit_check_prop() { # <dotted path> <value> [allow_newline]
  local path="$1" value="$2" probe="$2"
  [[ -n "$value" ]] || return 0
  if [[ "${3:-}" == "allow_newline" ]]; then probe="${probe//$'\n'/}"; fi
  case "$value" in
    *'${'*) ERRORS+=("$path: must not contain \${") ;;
  esac
  case "$value" in
    *'<'* | *'>'* | *'"'* | *'\'*) ERRORS+=("$path: must not contain < > \" or a backslash") ;;
  esac
  if [[ "$probe" =~ [[:cntrl:]] ]]; then
    ERRORS+=("$path: must not contain control characters")
  fi
  if [[ "$value" =~ ^[[:space:]] || "$value" =~ [[:space:]]$ ]]; then
    ERRORS+=("$path: must not start or end with whitespace")
  fi
  return 0
}

# One file name of the package: plain name, chart rule, exists in the source folder, no symlink.
_kit_check_file() { # <dotted path> <file name>
  local label="$1" name="$2" path
  [[ -n "$name" ]] || return 0
  if [[ "$name" == */* || "$name" == *\\* ]]; then
    ERRORS+=("$label: must be a plain file name inside the source folder, got: $name")
    return 0
  fi
  if [[ ! "$name" =~ $KIT_ASSET_NAME_RE ]]; then
    ERRORS+=("$label: invalid file name (start with a letter or digit; letters, digits, . _ - only; at most 100 characters): $name")
    return 0
  fi
  path="$SOURCE_DIR/$name"
  if [[ -L "$path" ]]; then
    ERRORS+=("$label: must not be a symbolic link: $path")
  elif [[ ! -f "$path" ]]; then
    ERRORS+=("$label: file not found: $path")
  fi
  return 0
}

# kit_report_errors: print ERRORS under one heading
kit_report_errors() {
  local e
  echo "$KIT_SCRIPT: validation failed:" >&2
  for e in "${ERRORS[@]}"; do echo "  - $e" >&2; done
}

# The only input checks (step 2):
#   kit_check_inputs <package> <schema> <asset_keys> <properties_paths>
# schema (all errors), asset files named by <asset_keys> (space-separated keys under .assets) exist in
# SOURCE_DIR and are no symlinks, file names follow the chart rule, and the safe characters of the values
# at <properties_paths> (space-separated yq paths, for values that reach a .properties file; a path ending
# in .* covers every key of that map, a path ending in :nl allows newlines; empty skips the policy).
# Not checked: sizes (the charts own them), email-logo content, links, theme content (the test harness owns it).
kit_check_inputs() {
  ERRORS=()
  local pkg="$1" schema="$2" asset_keys="$3" prop_paths="$4"
  local ajv_input="$TMP_ROOT/package.json" ajv_err="$TMP_ROOT/ajv.err" key pk line pp nl base
  if ! yq eval -o=json "$pkg" >"$ajv_input" 2>"$ajv_err"; then
    ERRORS+=("cannot parse $pkg: $(tr '\n' ' ' <"$ajv_err")")
    kit_report_errors
    return 1
  fi
  if ! ajv validate -s "$schema" --spec draft7 --all-errors --errors=text -d "$ajv_input" >"$ajv_err" 2>&1; then
    # ajv prints all errors on one comma-joined line; put one per line and drop its "<file> invalid" summary
    while IFS= read -r line; do
      if [[ -n "$line" && "$line" != *" invalid" ]]; then ERRORS+=("$line"); fi
    done < <(sed 's/, data\//\
data\//g' "$ajv_err")
  fi

  for key in $asset_keys; do
    _kit_check_file "assets.$key" "$(kit_str "$pkg" ".assets.$key")"
  done
  _kit_check_file "email.images.logo" "$(kit_str "$pkg" '.email.images.logo')"

  for pp in $prop_paths; do
    nl=""
    if [[ "$pp" == *:nl ]]; then nl="allow_newline"; pp="${pp%:nl}"; fi
    if [[ "$pp" == *.\* ]]; then
      base="${pp%.\*}"
      while IFS= read -r pk; do
        [[ -n "$pk" ]] || continue
        _kit_check_prop "${base#.}.$pk" "$(kit_str "$pkg" "$base.\"$pk\"")" "$nl"
      done < <(yq eval "$base // {} | keys | .[]" "$pkg" 2>/dev/null || true)
    else
      _kit_check_prop "${pp#.}" "$(kit_str "$pkg" "$pp")" "$nl"
    fi
  done

  [[ ${#ERRORS[@]} -eq 0 ]] || { kit_report_errors; return 1; }
}


# Path guards. kit_guard_target <target folder> <owned relative path>...
# Stops (returns 1 with a message) when the parent of the target does not exist, the target is a
# symlink or no folder, or an owned path (or anything below it) is a symlink. "." owns the whole folder.
kit_guard_target() {
  local dir="${1%/}" parent p comp cur rest
  shift
  parent=$(dirname "$dir")
  if [[ ! -d "$parent" ]]; then
    echo "$KIT_SCRIPT: parent folder does not exist: $parent" >&2
    return 1
  fi
  if [[ -L "$dir" ]]; then
    echo "$KIT_SCRIPT: $dir is a symbolic link; refusing to write through it" >&2
    return 1
  fi
  if [[ -e "$dir" && ! -d "$dir" ]]; then
    echo "$KIT_SCRIPT: $dir is not a folder" >&2
    return 1
  fi
  [[ -d "$dir" ]] || return 0
  for p in "$@"; do
    cur="$dir"
    rest="$p"
    while [[ -n "$rest" ]]; do
      comp="${rest%%/*}"
      if [[ "$rest" == */* ]]; then rest="${rest#*/}"; else rest=""; fi
      cur="$cur/$comp"
      if [[ -L "$cur" ]]; then
        echo "$KIT_SCRIPT: $cur is a symbolic link; refusing to write through it" >&2
        return 1
      fi
    done
    if [[ -d "$dir/$p" && -n "$(find "$dir/$p" -type l 2>/dev/null | head -n 1)" ]]; then
      echo "$KIT_SCRIPT: a symbolic link is inside $dir/$p: $(find "$dir/$p" -type l | head -n 1)" >&2
      return 1
    fi
  done
  return 0
}

# kit_stage <parent>: make a temporary folder next to the target (same file system); path in STAGE
kit_stage() {
  STAGE=$(mktemp -d "${1%/}/.kit-stage-XXXXXX")
  KIT_STAGES+=("$STAGE")
}

# kit_swap_file <staged file> <target>: rename over the target
kit_swap_file() {
  mv -f "$1" "$2"
}

# kit_swap_dir <staged folder> <target folder>: the old target goes aside, the staged folder takes
# its place, then the old copy is removed. The old copy comes back when the move fails.
kit_swap_dir() {
  local staged="$1" target="${2%/}" backup=""
  if [[ -e "$target" ]]; then
    backup="$(dirname "$target")/.kit-old-$$-$RANDOM"
    mv "$target" "$backup"
  fi
  if ! mv "$staged" "$target"; then
    if [[ -n "$backup" ]]; then mv "$backup" "$target"; fi
    return 1
  fi
  if [[ -n "$backup" ]]; then rm -rf "$backup"; fi
  return 0
}
