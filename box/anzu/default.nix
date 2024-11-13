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
    hostName = "anzu";
    firewall = {
      allowedTCPPorts = [ 3000 3456 8099 8384 8989 ];
      allowedUDPPorts = [ ];
    };
  };

  services.nebula.networks.asgard.firewall.inbound = [
    { port = 3001; proto = "tcp"; host = "any"; } # immich
  ];

  boot.kernelParams = [ "i915.enable_dc=0" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  systemd.oomd = {
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  system.stateVersion = "24.05";
}
