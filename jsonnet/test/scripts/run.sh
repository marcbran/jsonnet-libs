#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running tests..."

  local exit_code=0
  while read -r test; do
    local name
    name="$(echo "${test}" | cut -f 1)"
    local actual
    actual="$(echo "${test}" | cut -f 2)"
    local expected
    expected="$(echo "${test}" | cut -f 3)"

    if [ "${actual}" != "${expected}" ]; then
      echo "${name} failed!"
      echo "${expected} was expected"
      echo "${actual} was the actual value"
      echo ""
      exit_code=1
    fi
  done < <(jsonnet ./main.jsonnet | jq -r 'map([.name, .actual, .expected]) | .[] | @tsv')

  if [ "${exit_code}" -eq 0 ]; then
    echo "All tests passed!"
  else
    echo "Some tests failed!"
  fi
  exit "${exit_code}"
}

run
