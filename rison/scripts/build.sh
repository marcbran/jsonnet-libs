#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/rison"
  cp "main.libsonnet" "gen/rison"
}

build
