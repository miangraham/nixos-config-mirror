{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ../../common/desktop.nix
    ./headless-sway-vnc.nix
    ./euremote-sync.nix
  ];

  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_9;
  powerManagement.cpuFreqGovernor = "schedutil";
  system.stateVersion = "23.11";
}
