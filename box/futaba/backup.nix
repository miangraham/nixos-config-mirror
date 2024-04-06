{ pkgs, ... }:
let
  backupTime = "*-*-* *:04:00";
  hostname = "futaba";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs hostname; };
  home-ian-to-rnet = import ../../system/backup-home-to-rnet.nix { inherit pkgs hostname; };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni home-ian-to-rnet;

    srv-to-local = job {
      paths = [
        "/srv/freshrss"
        "/srv/home-assistant"
        "/srv/znc"
        "/var/backup"
        "/var/lib/invidious"
      ];
      startAt = "*-*-* *:17:00";
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };
  };
}
