{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
    ./services.nix
    ../../system
    ../../system/nebula-node.nix
    ../../system/pi4.nix
  ];

  networking = {
    hostName = "pika";
    firewall.allowedTCPPorts = [ 3001 ];
    nameservers = [ "192.168.0.127" "192.168.0.117" ];
  };

  hardware.raspberry-pi."4".i2c1.enable = true;

  system.stateVersion = "24.05";
}
