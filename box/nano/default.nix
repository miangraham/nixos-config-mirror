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

  # waybar pulseaudio module dies horribly without audio in 24.05
  home-manager.users.ian.programs.waybar.settings.main.modules-right = pkgs.lib.mkForce [
    "cpu"
    "memory"
    "disk"
    "network"
    "clock"
  ];

  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_9;
  powerManagement.cpuFreqGovernor = "schedutil";
  system.stateVersion = "23.11";
}
