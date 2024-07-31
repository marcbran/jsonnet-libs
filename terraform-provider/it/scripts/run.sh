#!/bin/bash
set -eu

function run() {
  cd "$(dirname "${0}")/.."

  trap ./scripts/clean.sh EXIT

  echo "Building terraform-provider..."
  go build -o terraform-provider ../main.go

  echo "Running terraform-provider..."
  ./terraform-provider --provider local --source hashicorp/local --output ./tf

  echo "Building jsonnet..."
  jsonnet ./tf/main.jsonnet >./tf/main.tf.json

  echo "Running Terraform..."
  terraform -chdir=./tf init
  terraform -chdir=./tf apply -auto-approve

  local expected="Hello World!"
  local actual
  actual="$(cat ./tf/actual.txt)"

  if ! [ "${actual}" == "${expected}" ]; then
    echo "${expected}, was expected"
    echo "${actual}, is the actual value"
    exit 1
  fi
}

run
