#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ `git status --porcelain` ]]; then
  echo "Outstanding git changes. Refusing to update."
  exit 1
fi

nix flake update
git add flake.lock
git commit -m "version bump"
