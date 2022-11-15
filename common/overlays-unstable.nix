{ pkgs, inputs, ... }:
let
  inherit (pkgs) system;
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });
  invidTestingOverlay = (self: super: {
    crystal = inputs.invid-testing.legacyPackages.${system}.crystal;
  });
in
[
  invidTestingOverlay
  inputs.emacs-overlay.overlay
]
