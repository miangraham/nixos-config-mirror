{ pkgs, inputs, ... }:
let
  overlays = import ./overlays-unstable.nix {inherit pkgs inputs;};
  conf = {
    inherit (pkgs) system;
    inherit overlays;
    config.allowUnfree = true;
  };
  unstable = (import inputs.unstable conf).pkgs;
in
unstable
