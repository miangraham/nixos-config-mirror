{ pkgs, inputs, ... }:
let
  overlays = [];
  conf = {
    inherit (pkgs) system;
    inherit overlays;
    config.allowUnfree = true;
  };
  unstable-small = (import inputs.unstable-small conf).pkgs;
in
unstable-small
