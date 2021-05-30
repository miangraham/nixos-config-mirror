{ ... }:
let
  sources = import ../nix/sources.nix;
  overlays = import ./overlays-stable.nix {};
  conf = {
    inherit overlays;
    config.allowUnfree = true;
    config.pulseaudio = true;
  };
  stable = import sources.nixpkgs conf;
in
stable
