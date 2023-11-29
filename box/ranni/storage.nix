{ config, pkgs, inputs, ... }:
{
  boot = {
    # defer to system default, currently using LTS
    # kernelPackages = pkgs.lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    zfs = {
      package = pkgs.zfs_2_1;
      devNodes = "/dev/disk/by-partlabel";
      extraPools = [ "srv" ];
      forceImportRoot = false;
    };
  };

  services = {
    zfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    sanoid = {
      enable = true;
      interval = "daily";
      templates.default = {
        autoprune = true;
        autosnap = true;
        hourly = 0;
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
