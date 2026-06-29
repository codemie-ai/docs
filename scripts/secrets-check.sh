#!/usr/bin/env bash
# Secrets detection using Gitleaks via Docker, Podman, or Apple Containers.
# Usage:
#   scripts/secrets-check.sh          # scan staged files
#   scripts/secrets-check.sh --git    # scan full git history

GITLEAKS_IMAGE="ghcr.io/gitleaks/gitleaks:v8.30.1"

# Find the first container engine whose daemon is actually running.
# Apple Containers uses `container` CLI with `container system status`.
CONTAINER_ENGINE=""
for engine in docker podman; do
  if command -v "$engine" >/dev/null 2>&1 && "$engine" info >/dev/null 2>&1; then
    CONTAINER_ENGINE=$(command -v "$engine")
    break
  fi
done

if [[ -z "$CONTAINER_ENGINE" ]] && command -v container >/dev/null 2>&1; then
  _container_status=$(container system status 2>/dev/null)
  if echo "$_container_status" | grep -q "container-apiserver" \
    && echo "$_container_status" | grep -qi "running"; then
    CONTAINER_ENGINE=$(command -v container)
  fi
  unset _container_status
fi

# If no running engine found, fall back to any installed engine for a helpful error
if [[ -z "$CONTAINER_ENGINE" ]]; then
  FALLBACK=$(command -v docker 2>/dev/null || command -v podman 2>/dev/null || command -v container 2>/dev/null)
  if [[ -z "$FALLBACK" ]]; then
    echo "No suitable container engine found - skipping secrets detection"
    echo "Install Docker, Podman, or Apple Containers to enable local secrets scanning"
    exit 1
  fi
  if command -v colima >/dev/null 2>&1; then
    echo "Container engine found but daemon is not running - Colima is installed"
    echo "Run 'colima start' to enable secrets detection locally"
  elif command -v podman >/dev/null 2>&1; then
    echo "Container engine found but daemon is not running - Podman is installed"
    echo "Run 'podman machine start' to enable secrets detection locally"
  elif command -v orbstack >/dev/null 2>&1; then
    echo "Container engine found but daemon is not running - OrbStack is installed"
    echo "Start OrbStack to enable secrets detection locally"
  elif command -v container >/dev/null 2>&1; then
    echo "Container engine found but daemon is not running - Apple Containers is installed"
    echo "Start Apple Containers to enable secrets detection locally"
  else
    echo "Container engine found but daemon is not running"
  fi
  exit 1
fi

echo "Checking for secrets with Gitleaks..."

CONFIG_FLAG=""
if [[ -f ".gitleaks.toml" ]]; then
  CONFIG_FLAG="--config /path/.gitleaks.toml"
fi

if [[ "$1" == "--git" ]]; then
  $CONTAINER_ENGINE run --rm -v "$(pwd):/path" "$GITLEAKS_IMAGE" git --no-banner --verbose $CONFIG_FLAG /path
else
  $CONTAINER_ENGINE run --rm -v "$(pwd):/path" "$GITLEAKS_IMAGE" dir --no-banner --verbose $CONFIG_FLAG /path
fi

if [[ $? -ne 0 ]]; then
  echo "Secrets detected! Please remove sensitive data before committing."
  exit 1
fi
