{ pkgs, ... }:
let
  backupTime = "*-*-* *:08:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  jobs = {
    home-ian-to-ranni = job {
      repo = "borg@ranni:fuuka";
      user = "ian";
      startAt = "*-*-* 06:00:00";
      prune = {
        keep = {
          hourly = 0;
          daily = 7;
          weekly = 3;
          monthly = 3;
        };
      };
    };

    srv-to-local = job {
      paths = [
        "/srv"
        "/var/backup"
        "/var/lib/nextcloud"
      ];
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
