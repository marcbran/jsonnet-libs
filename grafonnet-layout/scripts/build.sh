#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  mkdir -p "gen/grafonnet-layout"
  cp "main.libsonnet" "gen/grafonnet-layout"
}

build
