#!/bin/bash
set -eu

cd "$(dirname "${0}")/.."

echo "Cleaning up..."
docker-compose down
rm -f prom-metrics ./actual/prometheus.libsonnet
