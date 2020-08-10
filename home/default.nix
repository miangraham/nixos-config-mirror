let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  unstable = import sources.nixpkgs-unstable {};
  crate2nix = import sources.crate2nix {};
in
{
}
