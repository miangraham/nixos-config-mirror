{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./containers.nix
  ];

  my.home-network-only.enable = true;
  my.nebula-node.enable = true;

  networking = {
    hostName = "fuuka";
    firewall = {
      allowedTCPPorts = [ 80 443 7575 8008 8088 8384 9000 ];
      allowedUDPPorts = [ 8008 ];
    };
  };

  services.nebula.networks.asgard.firewall.inbound = [
    { port = 7575; proto = "tcp"; host = "any"; } # homepage
  ];

  boot.blacklistedKernelModules = [ "ite_cir" "iwlwifi" ];

  powerManagement = {
    cpuFreqGovernor = "conservative";
    powertop.enable = true;
  };

  system.stateVersion = "24.05";
}
