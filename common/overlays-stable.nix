{ ... }:
let
  emacsOverlay = import ((import ./paths.nix {}).emacs-overlay);
  swayOverlay = import ./sway-overlay.nix {};
in
[
  emacsOverlay
  # swayOverlay
]
