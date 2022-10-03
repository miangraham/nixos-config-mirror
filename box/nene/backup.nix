{ pkgs, ... }:
let
  backupTime = "*-*-* *:02:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-shared.nix {inherit pkgs backupTime;}) job;
  jobs = {
    home-ian-to-rnet = job {
      repo = "rnet:nene";
      user = "ian";
      encryption = {
        mode = "keyfile-blake2";
        passCommand = "cat /home/ian/.ssh/rnet_nene_phrase";
      };
      extraArgs = "--remote-path=borg1";
    };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
