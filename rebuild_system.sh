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

sudo -v

NIXOS_CONFIG=$CONF_LOC nixos-rebuild build -I $CONF_LOC --show-trace

sudo NIXOS_CONFIG=$CONF_LOC nixos-rebuild switch -I $CONF_LOC --show-trace

NIXOS_CONFIG=$CONF_LOC home-manager switch -I $CONF_LOC --show-trace

rm $DIR/result
