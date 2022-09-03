{ pkgs, inputs, ... }:
let
  conf = {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  dev = (import inputs.dev conf).pkgs;
in
dev
