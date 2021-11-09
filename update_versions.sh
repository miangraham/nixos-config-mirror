#!/bin/sh

set -e

nix flake lock --recreate-lock-file
