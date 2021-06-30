{ ... }:
let
  sources = import ../nix/sources.nix;
  overlays = import ./overlays-unstable.nix {};
  conf = {
    inherit overlays;
    config.allowUnfree = true;
    # config.pulseaudio = true;
  };
  unstable = import sources.nixpkgs-unstable conf;
in
unstable
