{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    # ./containers.nix
  ];

  my.home-network-only.enable = true;
  my.nebula-node.enable = true;

  networking = {
    hostName = "makoto";
    firewall = {
      allowedTCPPorts = [ 3000 3456 8099 8384 8989 ];
      allowedUDPPorts = [ ];
    };
  };

  services.nebula.networks.asgard.firewall.inbound = [
  ];

  powerManagement = {
    cpuFreqGovernor = "conservative";
    powertop.enable = true;
  };

  system.stateVersion = "24.05";
}
