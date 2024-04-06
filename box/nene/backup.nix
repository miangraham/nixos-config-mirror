{ pkgs, ... }:
let
  backupTime = "*-*-* *:02:00";
  hostname = "nene";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  home-ian-to-local = import ../../system/backup-home-to-local.nix { inherit pkgs; };
  home-ian-to-ranni = import ../../system/backup-home-to-ranni.nix { inherit pkgs hostname; };
  home-ian-to-rnet = import ../../system/backup-home-to-rnet.nix { inherit pkgs hostname; };
in
{
  jobs = {
    inherit home-ian-to-local home-ian-to-ranni home-ian-to-rnet;

    home-ian-to-usb = job {
      repo = "/run/media/ian/70F3-5B2F/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };
  };
}
