{ pkgs, ... }:
let
  backupTime = "*-*-* *:04:00";
  hostname = "futaba";
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs hostname; };
  home-ian-to-rnet = import ../../system/backup-home-to-rnet.nix { inherit pkgs hostname; };
  srv-to-ranni = import ../../system/backup-srv-to-ranni.nix {
    inherit pkgs hostname;
    paths = [
      "/srv/freshrss"
      "/srv/home-assistant"
      "/srv/znc"
      "/var/backup"
      "/var/lib/private/invidious"
    ];
  };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni home-ian-to-rnet srv-to-ranni;
  };
}
