#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" == "nene" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace
  sudo nix store sign -k /var/keys/nix-cache-key.priv --all
elif [[ "$HOSTNAME" == "futaba" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --override-input filter-tweets path:/home/ian/.nix/common/filter-tweets --option substituters ssh-ng://nix-ssh@nene --option trusted-public-keys 'nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ='
elif [[ "$HOSTNAME" == "rin" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --override-input filter-tweets path:/home/ian/.nix/common/filter-tweets --option substituters ssh-ng://nix-ssh@nene --option trusted-public-keys 'nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ='
else
  sudo nixos-rebuild switch --flake '.#' --show-trace --override-input filter-tweets path:/home/ian/.nix/common/filter-tweets
fi
