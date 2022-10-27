{ pkgs, inputs, ... }:
let
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });
in
[
  inputs.emacs-overlay.overlay
  # inputs.rust-overlay.overlays.default
]
