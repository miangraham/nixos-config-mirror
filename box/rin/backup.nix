{ pkgs, ... }:
let
  hostname = "rin";
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs hostname; };
  home-ian-to-rnet = import ../../system/backup-home-to-rnet.nix { inherit pkgs hostname; };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni home-ian-to-rnet;
  };
}
