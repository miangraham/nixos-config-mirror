{ config, pkgs, inputs, ... }:
let
in
{
  boot = {
    kernelPackages = pkgs.lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    zfs = {
      devNodes = "/dev/disk/by-partlabel";
      extraPools = [ "srv" ];
      forceImportRoot = false;
    };
  };

  hardware.sensor.hddtemp = {
    enable = true;
    drives = [
      "/dev/disk/by-id/ata-ST16000NT001-3LV101_WR50FMJJ"
      "/dev/disk/by-id/ata-ST16000NT001-3LV101_WR6039HH"
    ];
    dbEntries = [
      ''"ST16000NT001" 194 C "Seagate Ironwolf Pro 7200 SATA 16TB"''
    ];
  };

  services = {
    zfs = {
      autoScrub.enable = true;
    };

    sanoid = {
      enable = true;
      interval = "hourly";
      templates.default = {
        autoprune = true;
        autosnap = true;
        hourly = 12;
        daily = 7;
        monthly = 3;
        yearly = 0;
      };
      datasets.srv = {
        recursive = "zfs";
        useTemplate = [ "default" ];
      };
    };

    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = ranni
        netbios name = ranni
        security = user
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        timemachine = {
          path = "/srv/timemachine";
          public = "no";
          writeable = "yes";
          "valid users" = "timemachine";
          "force user" = "timemachine";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
        videos = {
          path = "/srv/videos";
          public = "no";
          writeable = "no";
          "valid users" = "ian";
          "force user" = "ian";
          "fruit:aapl" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };

  };
}