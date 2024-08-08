{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/home-network-only.nix
    ../../system/nebula-node.nix
    ./services.nix
    ./containers.nix
  ];

  networking = {
    hostName = "anzu";
    firewall = {
      allowedTCPPorts = [ 3456 8384 8099 ];
      allowedUDPPorts = [ ];
    };
  };

  boot.kernelParams = [ "i915.enable_dc=0" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  systemd.oomd = {
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  system.stateVersion = "24.05";
}
