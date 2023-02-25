{ pkgs, inputs, ... }:
let
  inherit (pkgs) system;
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });
in
[
  tdOverlay
  inputs.emacs-overlay.overlay
]
