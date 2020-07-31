{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/5d36f14d62da38e5f71c4dcc151ecbaa9feffbbc.tar.gz;
    }))
  ];
}
