{ pkgs, inputs, ... }:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
  ];

  my.base-boot.enable = false;

  raspberry-pi-nix.board = "bcm2712";
  nixpkgs.hostPlatform = "aarch64-linux";

  raspberry-pi-nix.libcamera-overlay.enable = false; # causes rebuilds of webkitgtk, qtwebengine, mozc, etc

  users.users.root.initialPassword = "root";
  users.users.ian.initialPassword = "ian";
}
