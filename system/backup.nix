{ pkgs, backupTime, ... }:
let
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
{
  borgbackup.jobs.home-ian-to-local = job {
    repo = "/borg";
    user = "root";
    preHook = ''
      mkdir -p /borg
    '';
  };
}
