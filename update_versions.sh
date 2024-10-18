#!/usr/bin/env bash

set -e

if [[ $(git status --porcelain) ]]; then
  echo "Outstanding git changes. Refusing to update."
  exit 1
fi

nix flake update
git add flake.lock

if [[ "$HOSTNAME" == "nene" ]]; then
  # Preview changes
  nixos-rebuild build --flake '.#'
  nvd diff /run/current-system ./result
  rm ./result
  read -r -p "Press ENTER to commit."
fi

git commit -m "version bump"
