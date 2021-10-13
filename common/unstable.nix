{ ... }:
let
  path = (import ./paths.nix {}).unstable;
  overlays = import ./overlays-unstable.nix {};
  conf = {
    inherit overlays;
    config.allowUnfree = true;
  };
  unstable = import path conf;
in
unstable
