{ ... }:
let
  sources = import ../nix/sources.nix;
  emacsOverlay = import sources.emacs-overlay;
in
[ emacsOverlay ]
