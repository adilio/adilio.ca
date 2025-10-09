#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION=${HUGO_VERSION:-0.151.0}
HUGO_IMAGE="klakegg/hugo:${HUGO_VERSION}-ext-alpine"
BUILD_DIR=${BUILD_DIR:-public}
REQUIRE_HUGO_BUILD=${REQUIRE_HUGO_BUILD:-false}
OLD_DOMAIN_PART1="adilio"
OLD_DOMAIN_PART2="io"

main() {
  check_domain_references

  if run_hugo_build; then
    exit 0
  fi

  if [[ "${REQUIRE_HUGO_BUILD}" == "true" ]]; then
    echo "Hugo build required but no compatible runner was available." >&2
    exit 1
  fi

  echo "Skipping Hugo build; install Hugo ${HUGO_VERSION} or start Docker to run the full test suite." >&2
}

check_domain_references() {
  local pattern="${OLD_DOMAIN_PART1}\\.${OLD_DOMAIN_PART2}"
  local search_cmd

  if command -v rg >/dev/null 2>&1; then
    search_cmd=(rg --no-heading --line-number -- "${pattern}" .)
  else
    search_cmd=(grep -RIn -- "${pattern}" .)
  fi

  if "${search_cmd[@]}"; then
    echo "Found lingering references to the old domain (${OLD_DOMAIN_PART1}.${OLD_DOMAIN_PART2})." >&2
    exit 1
  fi
}

run_hugo_build() {
  if run_hugo_locally; then
    return 0
  fi

  if run_hugo_with_docker; then
    return 0
  fi

  return 1
}

run_hugo_locally() {
  if ! command -v hugo >/dev/null 2>&1; then
    return 1
  fi

  local installed
  installed=$(hugo version | awk '{print $2}' | sed 's/^v//; s/+.*$//')

  if ! version_ge "${installed}" "${HUGO_VERSION}"; then
    echo "Detected Hugo ${installed}, which is older than the required ${HUGO_VERSION}; skipping local build." >&2
    return 1
  fi

  rm -rf "${BUILD_DIR}"
  hugo --gc --minify --panicOnWarning --destination "${BUILD_DIR}"
}

run_hugo_with_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    return 1
  fi

  if ! docker info >/dev/null 2>&1; then
    return 1
  fi

  rm -rf "${BUILD_DIR}"

  docker run --rm \
    -v "$(pwd)":/src \
    -w /src \
    "${HUGO_IMAGE}" \
    hugo --gc --minify --panicOnWarning --destination "${BUILD_DIR}"
}

version_ge() {
  local first
  first=$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n1)
  [[ "$first" == "$1" ]]
}

main "$@"
