#!/bin/bash
set -eu

cd "$(dirname "${0}")/.."

echo "Cleaning up..."
rm -rf terraform-provider ./tf/registry.terraform.io ./tf/.terraform* ./tf/terraform* ./tf/main.tf.json ./tf/actual.txt
