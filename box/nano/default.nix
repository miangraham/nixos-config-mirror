{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ../../common/desktop.nix
    ./headless-sway-vnc.nix
  ];

  boot.blacklistedKernelModules = [ ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad;
  };

  powerManagement.cpuFreqGovernor = "schedutil";
  system.stateVersion = "23.11";
}
