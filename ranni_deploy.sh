#!/bin/sh

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$HOSTNAME" != "nene" ]]; then
  echo "Not running from known deployer. Abort."
  exit 1
fi

if [[ `git status --porcelain` ]]; then
  echo "Outstanding git changes. Refusing to build."
  exit 1
fi

# Build

nix build .#nixosConfigurations.ranni.config.system.build.toplevel --out-link /tmp/result
OUTPUT=$(readlink /tmp/result)
echo "Built: ${OUTPUT}"

# Copy

nix copy "${OUTPUT}" --to ssh://ian@ranni

# Switch profiles

SWITCH_CMD="/run/current-system/sw/bin/nix-env -p /nix/var/nix/profiles/system --set ${OUTPUT} && /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
ssh -t ranni "sudo sh -c \"${SWITCH_CMD}\""
