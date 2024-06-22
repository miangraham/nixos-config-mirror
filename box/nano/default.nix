{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/home-network-only.nix
    ../../common/desktop.nix
    ./headless-sway-vnc.nix
    ./euremote-sync.nix
  ];

  networking = {
    hostName = "nano";
    firewall = {
      allowedTCPPorts = [ 8384 ];
      allowedUDPPorts = [ ];
    };
  };

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

  services.syncthing.guiAddress = "0.0.0.0:8384";

  system.stateVersion = "24.05";
}
