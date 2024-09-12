#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/promql"
  cp "main.libsonnet" "gen/promql"
}

build
