#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/terraform"
  cp "main.libsonnet" "gen/terraform"
}

build
