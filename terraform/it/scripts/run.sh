#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running integration tests..."

  trap ./scripts/clean.sh EXIT

  echo "Evaluating Jsonnet..."
  local exit_code=0
  while read -r tst; do
    local it; it="$(echo "${tst}" | jq -r '.[0]')"
    if [ "${it}" != "true" ]; then
      continue
    fi

    local actual; actual="$(echo "${tst}" | jq -r '.[1]')"
    mkdir -p tf
    touch tf/example.txt
    echo "${actual}" > tf/main.tf.json
    terraform -chdir=tf init
    terraform -chdir=tf plan
    rm -rf tf

  done < <(jsonnet '../test/main.jsonnet' | jq -rc 'map([.it, .actual]) | .[]')

  if [ "${exit_code}" -eq 0 ]; then
    echo "All tests passed!"
  else
    echo "Some tests failed!"
  fi
  exit "${exit_code}"
}

run
