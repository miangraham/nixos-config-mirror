#!/usr/bin/env bash

set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" == "nene" ]]; then
  nixos-rebuild dry-build --flake '.#'
else
  nixos-rebuild dry-build --flake '.#' --show-trace
fi
