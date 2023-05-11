{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
  yt-dlp = import ../../home/yt-dlp.nix { inherit pkgs inputs; };
in
{
  services = {
    inherit borgbackup;

    navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/music";
        ScanSchedule = "@daily";
      };
    };

    prometheus = {
      enable = true;
      port = 9090;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
        zfs = {
          enable = true;
          pools = [ "srv" ];
        };
      };
      scrapeConfigs = [{
        job_name = "system";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      } {
        job_name = "zfs";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}" ];
        }];
      }];
    };

    netdata.enable = false;

    syncthing.guiAddress = "0.0.0.0:8384";

    pipewire.enable = pkgs.lib.mkForce false;
  };

  systemd.services.pmbridge = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    environment = {
      PASSWORD_STORE_DIR = "/home/ian/.local/share/password-store";
    };
    path = [
      unstable.protonmail-bridge
      pkgs.pass
    ];
    script = "protonmail-bridge -n";
  };

  systemd.services.pueue = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      yt-dlp
      pkgs.pueue
      pkgs.aria2
    ];
    script = "pueued -v";
  };
}
