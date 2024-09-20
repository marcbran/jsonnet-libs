#!/bin/bash
set -eu

function clean {
  cd "$(dirname "${0}")/.."

  echo "Cleaning up..."
#  docker-compose down
}

clean
