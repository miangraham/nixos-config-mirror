{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/pi4.nix
  ];

  hardware.raspberry-pi."4".pwm0.enable = true;

  networking = {
    hostName = "rika";
    firewall.allowedTCPPorts = [ ];
  };

  system.stateVersion = "23.11";
}
