#!/bin/bash
set -eu

function gen() {
  cd "$(dirname "${0}")/.."

  go run main.go -provider local -source local -output gen
  go run main.go -provider aws -source aws -output gen
  go run main.go -provider azurerm -source azurerm -output gen
  go run main.go -provider google -source google -output gen
  go run main.go -provider kubernetes -source kubernetes -output gen
  go run main.go -provider github -source integrations/github -output gen
  go run main.go -provider dolt -source marcbran/dolt -output gen
  go run main.go -provider jsonnet -source marcbran/jsonnet -output gen
}

gen
