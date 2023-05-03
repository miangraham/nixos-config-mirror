{ pkgs, ... }:
let
  backupTime = "*-*-* *:02:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  jobs = {
    home-ian-to-usb = job {
      repo = "/run/media/ian/70F3-5B2F/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };

    home-ian-to-rnet = job {
      repo = "rnet:nene";
      user = "ian";
      doInit = false;
      encryption = {
        mode = "keyfile-blake2";
        passCommand = "cat /home/ian/.ssh/rnet_nene_phrase";
      };
      extraArgs = "--remote-path=borg1";
    };

    home-ian-to-ranni = job {
      repo = "borg@ranni:nene";
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
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
