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

    syncthing.guiAddress = "0.0.0.0:8384";

    pipewire.enable = pkgs.lib.mkForce false;
  };
}
