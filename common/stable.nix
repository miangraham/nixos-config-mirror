{ ... }:
let
  path = (import ./paths.nix {}).stable;
  overlays = import ./overlays-stable.nix {};
  conf = {
    inherit overlays;
    config.allowUnfree = true;
  };
  stable = import path conf;
in
stable
