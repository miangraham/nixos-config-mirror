{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ./services.nix
    ./containers.nix
    ./nextcloud.nix
  ];

  boot.blacklistedKernelModules = [ "ite_cir" "iwlwifi" ];

  powerManagement = {
    cpuFreqGovernor = "conservative";
    powertop.enable = true;
  };

  system.stateVersion = "23.11";
}