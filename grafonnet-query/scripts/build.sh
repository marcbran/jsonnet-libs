#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/grafonnet-query"
  cp "main.libsonnet" "gen/grafonnet-query"
}

build
