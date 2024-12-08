{ config, lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./containers.nix
  ];

  my.audio.enable = true;
  my.backup.home-to-local.enable = true;
  my.backup.home-to-ranni.enable = true;
  my.backup.home-to-rnet.enable = true;
  my.backup.home-to-usb = {
    enable = true;
    repo = "/run/media/ian/70F3-5B2F/borg";
  };
  my.desktop.enable = true;
  my.gaming.enable = true;
  my.home-network-only.enable = true;
  my.nebula-node.enable = true;
  my.streaming.enable = true;

  networking = {
    hostName = "nene";
    firewall.allowedTCPPorts = [ 80 443 5672 6379 8443 41641 ];
  };

  # temp pin, system locked on 2024-12-08. kernel or bios?
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;
  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    "net.ipv4.tcp_fin_timeout" = 10;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.users.ian.home.packages = with pkgs; [];

  system.stateVersion = "24.05";
}
