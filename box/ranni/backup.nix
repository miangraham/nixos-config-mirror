{ pkgs, config, ... }:
let
  backupTime = "*-*-* *:17:00";
  inherit (import ../../modules/backup/backup-utils.nix {inherit pkgs backupTime;}) job;
in
{
  jobs = {
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
