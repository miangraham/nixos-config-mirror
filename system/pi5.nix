{ pkgs, inputs, ... }:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
  ];

  my.base-boot.enable = false;

  raspberry-pi-nix.board = "bcm2712";
  nixpkgs.hostPlatform = "aarch64-linux";
}
