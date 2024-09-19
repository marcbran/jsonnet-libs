#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/jsonnet"
  cp "main.libsonnet" "gen/jsonnet"
  cp "main.libsonnet" "../prom2jsonnet/tmpl/jsonnet.libsonnet"
}

build
