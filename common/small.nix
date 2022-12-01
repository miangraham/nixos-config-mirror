{ pkgs, inputs, ... }:
let
  overlays = [];
  conf = {
    inherit (pkgs) system;
    inherit overlays;
    config.allowUnfree = true;
  };
in
(import inputs.small conf).pkgs;
