#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running integration tests..."

  trap ./scripts/clean.sh EXIT

  echo "Evaluating Jsonnet..."
  local exit_code=0
  while read -r query; do
    echo "${query}"

    local response
    set +e
    response="$(jsonnet -e "${query}")"
    if ! jsonnet -e "${query}" >/dev/null 2>&1; then
      exit_code=1
    fi
    set -e
    echo "${response}"

  done < <(jsonnet '../test/main.jsonnet' | jq -r 'map(.actual) | .[]')

  if [ "${exit_code}" -eq 0 ]; then
    echo "All tests passed!"
  else
    echo "Some tests failed!"
  fi
  exit "${exit_code}"
}

run
