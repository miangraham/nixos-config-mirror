{ ... }:
let
  emacsOverlay = import ../common/emacs-overlay.nix {};
  mozOverlay = import ../common/mozilla-overlay.nix {};
in
[ emacsOverlay mozOverlay ]
