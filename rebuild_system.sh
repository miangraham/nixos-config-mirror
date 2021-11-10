#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" == "nene" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace
elif [[ "$HOSTNAME" == "futaba" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --override-input filter-tweets path:/home/ian/.nix/common/filter-tweets --option substituters ssh://nix-ssh@nene
else
  sudo nixos-rebuild switch --flake '.#' --show-trace --override-input filter-tweets path:/home/ian/.nix/common/filter-tweets
fi
