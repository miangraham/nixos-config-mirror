{ pkgs, hostname, ... }:
let
  backupTime = "*-*-* 04:00:00";
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
job {
  repo = "borg@ranni:${hostname}";
  user = "ian";
  persistentTimer = true;
  prune = {
    keep = {
      hourly = 0;
      daily = 7;
      weekly = 3;
      monthly = 3;
    };
  };
}
