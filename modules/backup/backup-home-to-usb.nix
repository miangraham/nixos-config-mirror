{ pkgs, config, repo, ... }:
let
  backupTime = "*-*-* *:02:00";
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
job {
  inherit repo;
  user = "ian";
  doInit = false;
  removableDevice = true;
}
