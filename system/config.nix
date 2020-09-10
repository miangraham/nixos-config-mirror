{ ... }:
let
  overlays = import ../common/overlays.nix {};
in
{
  config.allowUnfree = true;
  config.pulseaudio = true;
  overlays = overlays;
}
