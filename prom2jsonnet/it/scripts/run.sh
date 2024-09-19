#!/bin/bash
set -eu

cd "$(dirname "${0}")/.."

trap ./scripts/clean.sh EXIT

echo "Building prom2jsonnet..."
go build -o prom2jsonnet ../main.go

echo "Starting Docker Compose..."
docker-compose up -d

echo "Waiting for Prometheus to start..."
while true; do
    if curl -s -o /dev/null http://localhost:9090/metrics; then
        break
    fi
  sleep 1
done

echo "Running prom2jsonnet..."
./prom2jsonnet --url=http://localhost:9090/metrics --output ./actual prometheus

if [ -f "./actual/prometheus.libsonnet" ]; then
    if diff "./actual/prometheus.libsonnet" "./expected/prometheus.libsonnet"; then
        echo "Integration test passed."
    else
        echo "Integration test failed. Output file does not match expected output."
        exit 1
    fi
else
    echo "Integration test failed. Output file not found."
    exit 1
fi
