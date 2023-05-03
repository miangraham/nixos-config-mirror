{ pkgs, ... }:
let
  backupTime = "*-*-* *:17:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  jobs = {};
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
