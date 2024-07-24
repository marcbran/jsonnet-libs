#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running integration tests..."

  trap ./scripts/clean.sh EXIT

  echo "Starting Docker Compose..."
  docker-compose up -d

  echo "Waiting for Prometheus to start..."
  while ! curl -s -o /dev/null http://localhost:9090/metrics; do
    sleep 1
  done

  echo "Querying Prometheus..."
  local exit_code=0
  while read -r query; do
    echo "${query}"

    local response
    response="$(curl -sG --data-urlencode "query=${query}" "http://localhost:9090/api/v1/query")"
    local status
    status="$(echo "${response}" | jq -r '.status')"

    if [ "${status}" != "success" ]; then
      local error
      error="$(echo "${response}" | jq -r '.error')"
      echo "${error}"
      echo ""
      exit_code=1
    fi
  done < <(jsonnet '../test/main.jsonnet' | jq -r 'map(.actual) | .[]')

  if [ "${exit_code}" -eq 0 ]; then
    echo "All tests passed!"
  else
    echo "Some tests failed!"
  fi
  exit "${exit_code}"
}

run
