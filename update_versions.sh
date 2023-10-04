#!/usr/bin/env bash

set -e

if [[ $(git status --porcelain) ]]; then
  echo "Outstanding git changes. Refusing to update."
  exit 1
fi

nix flake update
git add flake.lock
git commit -m "version bump"
