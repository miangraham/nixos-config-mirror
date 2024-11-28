{ pkgs, ... }:
let
  backupTime = "*-*-* *:02:00";
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
job {
  repo = "/borg";
  user = "root";
  persistentTimer = true;
  preHook = ''
    mkdir -p /borg
  '';
}
