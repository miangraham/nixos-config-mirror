#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONF_LOC=$DIR/system/configuration.nix

NIXOS_CONFIG=$CONF_LOC nixos-rebuild dry-build -I $CONF_LOC
