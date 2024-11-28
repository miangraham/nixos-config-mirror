{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ./containers.nix
    ./services.nix
    ../../system/pi4.nix
  ];

  my.backup.home-to-usb = {
    enable = true;
    repo = "/run/media/ian/70F8-1012/borg";
  };
  my.backup.srv-to-ranni = {
    enable = true;
    paths = [ "/srv" ];
  };
  my.home-network-only.enable = true;
  my.nebula-node.enable = true;

  networking = {
    hostName = "pika";
    firewall.allowedTCPPorts = [ 3001 ];
  };

  hardware.raspberry-pi."4".i2c1.enable = true;

  system.stateVersion = "24.05";
}
