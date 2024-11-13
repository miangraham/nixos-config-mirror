#!/usr/bin/env bash

set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

nixos-rebuild build --flake '.#' --show-trace
nvd diff /run/current-system ./result
rm ./result
