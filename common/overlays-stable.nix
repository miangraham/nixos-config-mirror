{ ... }:
let
  sources = import ../nix/sources.nix;
  emacsOverlay = import sources.emacs-overlay;
  swayOverlay = import ./sway-overlay.nix {};
in
[ emacsOverlay swayOverlay ]
