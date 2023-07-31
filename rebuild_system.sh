#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" == "nene" ]]; then
  # Preview changes
  nixos-rebuild build --flake '.#'
  nvd diff /run/current-system ./result
  read -p "Press ENTER to apply."

  # Apply
  rm ./result
  sudo nixos-rebuild switch --flake '.#' --print-build-logs
  sudo nix store sign -k /var/keys/nix-cache-key.priv --all
elif [[ "$HOSTNAME" == "futaba" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --option extra-substituters ssh-ng://nix-ssh@nene --option extra-trusted-public-keys 'nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ='
elif [[ "$HOSTNAME" == "ranni" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --option extra-substituters ssh-ng://nix-ssh@nene --option extra-trusted-public-keys 'nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ='
elif [[ "$HOSTNAME" == "rin" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace --option extra-substituters ssh-ng://nix-ssh@nene --option extra-trusted-public-keys 'nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ='
else
  sudo nixos-rebuild switch --flake '.#' --show-trace
fi
