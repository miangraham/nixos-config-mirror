{ pkgs, ... }:
let
  hostname = "anzu";
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs hostname; };
  srv-to-ranni = import ../../system/backup-srv-to-ranni.nix {
    inherit pkgs hostname;
    paths = [
      "/srv"
      "/var/lib/private/vikunja"
    ];
  };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni srv-to-ranni;
  };
}
