#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  nix-env -irf $DIR/home
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "No user profile packages on darwin!"
  exit 1
else
  echo "Unexpected OS"
  exit 1
fi
