#!/bin/bash
set -eu

function clean {
  cd "$(dirname "${0}")/.."

  echo "Cleaning up..."
  docker-compose down
  local pid; pid="$(cat pid.txt)"
  kill "${pid}"
  rm "pid.txt" || true
}

clean
