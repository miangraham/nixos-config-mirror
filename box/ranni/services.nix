{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  # borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    # inherit borgbackup;

    zfs = {
      autoScrub.enable = true;
    };

    sanoid = {
      enable = true;
      interval = "daily";
      templates.default = {
        autosnap = true;
        hourly = 0;
        daily = 7;
        monthly = 1;
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

    syncthing.guiAddress = "0.0.0.0:8384";

    pipewire.enable = pkgs.lib.mkForce false;
  };
}
