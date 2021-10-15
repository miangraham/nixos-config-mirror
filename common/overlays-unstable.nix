{ ... }:
let
  paths = import ./paths.nix {};
  emacsOverlay = import paths.emacs-overlay;
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      inherit (paths.tdlib) version src;
    });
  });
in
[ tdOverlay emacsOverlay ]
