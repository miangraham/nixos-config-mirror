#!/usr/bin/env bash

set -ex

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" != "nene" ]]; then
  echo "Not running from known deployer. Abort."
  exit 1
fi

if [[ $(git status --porcelain) ]]; then
  echo "Outstanding git changes. Refusing to build."
  exit 1
fi

# Build

mkdir -p ./builds
nix build .#nixosConfigurations.makoto.config.system.build.toplevel --out-link ./builds/makoto
OUTPUT=$(readlink ./builds/makoto)
echo "Built: ${OUTPUT}"

# Copy

nix copy "${OUTPUT}" --to ssh://ian@makoto

# Switch profiles

SWITCH_CMD="/run/current-system/sw/bin/nix-env -p /nix/var/nix/profiles/system --set ${OUTPUT} && /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
ssh -t makoto "sudo sh -c \"${SWITCH_CMD}\""