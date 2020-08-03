{ ... }:
{
  nixpkgs.overlays = [
    (import ./emacs-overlay.nix {})
  ];
}
