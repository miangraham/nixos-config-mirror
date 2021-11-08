#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONF_LOC=$DIR/configuration.nix

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Unexpected OS. Abort."
  exit 1
fi

if [[ "$USER" != "ian" ]]; then
   echo 'Run as normal user.'
   exit 1
fi

if ! test -f $CONF_LOC; then
  echo "Link box config to ./configuration.nix before running."
  exit 1
fi

# nixos-rebuild build --flake '.#' --show-trace

# echo "Build done. Switching..."

sudo nixos-rebuild switch --flake '.#' --show-trace

# rm $DIR/result
