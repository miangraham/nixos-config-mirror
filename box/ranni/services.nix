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

    syncthing.guiAddress = "0.0.0.0:8384";

    pipewire.enable = pkgs.lib.mkForce false;
  };
}
