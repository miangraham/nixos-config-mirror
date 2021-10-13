{ ... }:
let
  emacsOverlay = import ((import ./paths.nix {}).emacs-overlay);
in
[ emacsOverlay ]
