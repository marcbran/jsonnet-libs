#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."
  echo "Running integration tests..."

  trap ./scripts/clean.sh EXIT

  echo "Starting Docker Compose..."
  docker-compose up -d

  echo "Installing jsonnet dependencies..."
  jb install

  echo "Waiting for Grafana to start..."
  while ! curl -s -o /dev/null http://localhost:3000/metrics; do
    sleep 1
  done

  local code;
  code="$(jsonnet -J vendor ./main.jsonnet | \
  curl -o /dev/null -s -w "%{http_code}\n" -X POST \
    -H "Content-Type: application/json" \
    http://localhost:3000/api/dashboards/db \
    --data-binary @- | \
  tail -n 1)"

  if [ "${code}" == "200" ]; then
    echo "Test passed!"
    exit 0
  else
    echo "Test failed!"
    exit 1
  fi
}

run
