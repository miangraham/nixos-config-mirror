{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/home-network-only.nix
    ./services.nix
    ./containers.nix
  ];

  networking = {
    hostName = "futaba";
    firewall = {
      allowedTCPPorts = [ 80 443 1883 4533 8081 8089 8092 8384 8443 8448 8989 9090 41641 ];
      allowedUDPPorts = [ 5354 8448 ];
    };
  };

  hardware.bluetooth.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  system.stateVersion = "24.05";
}
