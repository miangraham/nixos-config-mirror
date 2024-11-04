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

  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_11;
  # powerManagement.cpuFreqGovernor = "schedutil";
  hardware.deviceTree.enable = true;
  # hardware.deviceTree.filter = "*nanopi-r6c*.dtb";
  hardware.deviceTree.name = "rockchip/rk3588s-nanopi-r6c.dtb";

  # xdg-desktop-portal-gtk failing startup on kernel 6.10
  xdg.portal.enable = pkgs.lib.mkForce false;
  xdg.portal.extraPortals = pkgs.lib.mkForce [ ];

  home-manager.users.ian.systemd.user.services.autotiling.Service.ExecStartPre = "/run/current-system/sw/bin/sleep 5";
  home-manager.users.ian.systemd.user.services.sworkstyle.Service.ExecStartPre = "/run/current-system/sw/bin/sleep 5";

  services.kanata.enable = pkgs.lib.mkForce false;

  system.stateVersion = "24.05";
}
