#!/bin/bash
set -eu

cd "$(dirname "${0}")/.."

echo "Cleaning up..."
rm -rf terraform-provider ./tf/local ./tf/.terraform* ./tf/terraform* ./tf/main.tf.json ./tf/actual.txt
