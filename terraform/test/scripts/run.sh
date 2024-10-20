#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running tests..."

  local exit_code=0
  while read -r test; do
    local actual
    actual="$(echo "${test}" | cut -f 1)"
    local expected
    expected="$(echo "${test}" | cut -f 2)"

    if [ "${actual}" != "${expected}" ]; then
      echo "${expected} was expected"
      echo "${actual} was the actual value"
      exit_code=1
    fi
  done < <(jsonnet ./main.jsonnet | jq -r 'map([(.actual | tostring), (.expected | tostring)]) | .[] | @tsv')

  if [ "${exit_code}" -eq 0 ]; then
    echo "All tests passed!"
  else
    echo "Some tests failed!"
  fi
  exit "${exit_code}"
}

run
