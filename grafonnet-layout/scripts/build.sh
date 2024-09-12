#!/bin/bash
set -eu

function build() {
  cd "$(dirname "${0}")/.."
  cp "main.libsonnet" "gen"
}

build
