#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

sudo nixos-rebuild switch --flake '.#' --show-trace
