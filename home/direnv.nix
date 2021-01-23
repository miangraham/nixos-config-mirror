{ ... }:
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
in
{
  enable = true;
  enableBashIntegration = true;
  enableNixDirenvIntegration = true;
}
