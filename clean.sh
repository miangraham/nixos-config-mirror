#!/usr/bin/env bash

set -ex

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

home-manager expire-generations '-14 days'
sudo nix-collect-garbage --delete-older-than 14d

home-manager generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
