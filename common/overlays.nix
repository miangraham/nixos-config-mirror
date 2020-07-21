{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/4c75f3945cf0986c8f6092dd77c7b77176b35617.tar.gz;
    }))
  ];
}
