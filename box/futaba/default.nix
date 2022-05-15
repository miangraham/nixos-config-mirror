{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
    ./services.nix
  ];

  networking = {
    hostName = "futaba";
    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 2222 4533 8081 8384 8443 8989 9090 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  system.stateVersion = "21.05";
}
