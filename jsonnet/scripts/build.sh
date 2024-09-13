#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/jsonnet"
  cp "main.libsonnet" "gen/jsonnet"
}

build
