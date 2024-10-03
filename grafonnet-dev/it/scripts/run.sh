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

  export GRAFANA_SCHEME="http"
  export GRAFANA_HOST="localhost:3000"
  export GRAFANA_API_ACCESS_TOKEN=""

  local output; output="$(mktemp)"

  echo "Running grafonnet-dev..."
  go run ../main.go main.jsonnet >> "${output}" 2>&1 &
  local pid=$!
  echo "${pid}" > pid.txt

  sleep 10
  perl -pi -w -e 's/Faro dashboard/Test Faro dashboard/g' main.jsonnet
  sleep 10
  perl -pi -w -e 's/Test Faro dashboard/Faro dashboard/g' main.jsonnet
  sleep 10

  if diff -q "${output}" expected.txt > /dev/null; then
      echo "File contents match"
      exit 0
  else
      echo "File contents do not match"
      echo "expected:"
      cat "expected.txt"
      echo "actual:"
      cat "${output}"
      exit 1
  fi
}

run
