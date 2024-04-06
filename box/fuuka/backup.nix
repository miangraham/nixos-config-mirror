{ pkgs, ... }:
let
  backupTime = "*-*-* *:08:00";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs; hostname = "fuuka"; };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni;

    srv-to-local = job {
      startAt = "*-*-* *:16:00";
      paths = [
        "/etc/dendrite"
        "/srv"
        "/var/backup"
        "/var/lib/private/dendrite"
        "/var/lib/nextcloud"
      ];
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };
  };
}
