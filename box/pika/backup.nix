{ pkgs, ... }:
let
  backupTime = "*-*-* *:10:00";
  hostname = "pika";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
  srv-to-ranni = import ../../system/backup-srv-to-ranni.nix {
    inherit pkgs hostname;
    paths = [ "/srv" ];
  };
in
{
  jobs = {
    inherit srv-to-ranni;

    home-ian-to-usb = job {
      repo = "/run/media/ian/70F8-1012/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };
  };
}
