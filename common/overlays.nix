{ ... }:
let
  sources = import ../nix/sources.nix;
  emacsOverlay = import sources.emacs-overlay;
  mozOverlay = import sources.nixpkgs-mozilla;
in
[ emacsOverlay mozOverlay ]
