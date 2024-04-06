{ pkgs, ... }:
let
  backupTime = "*-*-* *:10:00";
  inherit (import ../../system/backup-utils.nix {inherit pkgs backupTime;}) job;
in
{
  jobs = {
    home-ian-to-usb = job {
      repo = "/run/media/ian/70F8-1012/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };

    srv-to-ranni = job {
      repo = "borg@ranni:pika";
      paths = [
        "/srv"
      ];
      startAt = "*-*-* 04:10:00";
      prune = {
        keep = {
          hourly = 0;
          daily = 7;
          weekly = 3;
          monthly = 3;
        };
      };
      environment.BORG_RSH = "ssh -i /home/ian/.ssh/id_ed25519";
    };
  };
}
