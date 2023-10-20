{ pkgs, ... }:
let
  backupTime = "*-*-* *:06:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  jobs = {
    # home-ian-to-rnet = job {
    #   repo = "rnet:rin";
    #   user = "ian";
    #   doInit = false;
    #   persistentTimer = true;
    #   encryption = {
    #     mode = "keyfile-blake2";
    #     passCommand = "cat /home/ian/.ssh/rnet_rin_phrase";
    #   };
    #   extraArgs = "--remote-path=borg1";
    # };
    # home-ian-to-ranni = job {
    #   repo = "borg@ranni:rin";
    #   user = "ian";
    #   startAt = "*-*-* 04:00:00";
    #   persistentTimer = true;
    #   prune = {
    #     keep = {
    #       hourly = 0;
    #       daily = 7;
    #       weekly = 3;
    #       monthly = 3;
    #     };
    #   };
    # };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
