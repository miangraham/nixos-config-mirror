{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/pi4.nix
  ];

  networking = {
    hostName = "mika";
    firewall.allowedTCPPorts = [ ];
  };

  system.stateVersion = "23.11";
}
