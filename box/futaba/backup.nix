{ pkgs, ... }:
let
  backupTime = "*-*-* *:04:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-shared.nix {inherit pkgs backupTime;}) job;
  jobs = {
    rss-to-local = job {
      paths = [ "/srv/freshrss" ];
      startAt = "*-*-* *:07:00";
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
