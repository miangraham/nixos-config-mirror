{ pkgs, ... }:
let
  backupTime = "*-*-* *:17:00";
  hostname = "ranni";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-rnet = import ../../system/backup-home-to-rnet.nix { inherit pkgs hostname; };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-rnet;

    home-ian-to-ranni = job {
      repo = "/srv/borg/ranni";
      user = "root";
      startAt = "*-*-* 04:00:00";
      prune = {
        keep = {
          hourly = 0;
          daily = 7;
          weekly = 3;
          monthly = 3;
        };
      };
    };
  };
}
