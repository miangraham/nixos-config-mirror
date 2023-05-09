{ pkgs, ... }:
let
  backupTime = "*-*-* *:17:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
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
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
