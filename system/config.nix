{ ... }:
let emacsOverlay = import ../common/emacs-overlay.nix {};
in
{
  config.allowUnfree = true;
  config.pulseaudio = true;
  overlays = [ emacsOverlay ];
}
