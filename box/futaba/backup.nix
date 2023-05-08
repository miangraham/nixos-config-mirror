{ pkgs, ... }:
let
  backupTime = "*-*-* *:04:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  jobs = {
    home-ian-to-rnet = job {
      repo = "rnet:futaba";
      user = "ian";
      doInit = false;
      encryption = {
        mode = "keyfile-blake2";
        passCommand = "cat /home/ian/.ssh/rnet_futaba_phrase";
      };
      extraArgs = "--remote-path=borg1";
    };

    home-ian-to-ranni = job {
      repo = "borg@ranni:futaba";
      user = "ian";
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

    rss-to-local = job {
      paths = [ "/srv/freshrss" ];
      startAt = "*-*-* *:07:00";
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };

    music-to-rnet = {
      repo = "rnet:futaba";
      paths = [ "/srv/music" ];
      user = "ian";
      doInit = false;
      startAt = "weekly";
      # startAt = "daily";
      prune = {
        keep = {
          daily = 3;
          weekly = 3;
          monthly = 3;
        };
      };
      compression = "auto,zstd";
      extraArgs = "--remote-path=borg1";
      encryption = {
        mode = "keyfile-blake2";
        passCommand = "cat /home/ian/.ssh/rnet_futaba_phrase";
      };
    };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
