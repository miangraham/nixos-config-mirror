#!/usr/bin/env bash

set -e

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" == "nene" ]]; then
  # Preview changes
  nixos-rebuild build --flake '.#'
  nvd diff /run/current-system ./result
  rm ./result
  read -r -p "Press ENTER to apply."

  # Apply
  sudo nixos-rebuild switch --flake '.#' --print-build-logs
  sudo nix store sign -k /var/keys/nix-cache-key.priv --all
elif [[ "$HOSTNAME" == "rin" ]]; then
  sudo nixos-rebuild switch --flake '.#' --show-trace
else
  sudo nixos-rebuild switch --flake '.#' --show-trace
fi
