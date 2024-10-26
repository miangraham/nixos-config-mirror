{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/home-network-only.nix
    # ../../system/nebula-node.nix
    ./services.nix
    # ./containers.nix
  ];

  networking = {
    hostName = "makoto";
    firewall = {
      allowedTCPPorts = [ 3000 3456 8099 8384 8989 ];
      allowedUDPPorts = [ ];
    };
  };

  # services.nebula.networks.asgard.firewall.inbound = [
  #   { port = 3001; proto = "tcp"; host = "any"; } # immich
  # ];

  powerManagement = {
    cpuFreqGovernor = "conservative";
    powertop.enable = true;
  };

  system.stateVersion = "24.05";
}
