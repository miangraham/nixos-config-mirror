{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./containers.nix
  ];

  my.backup.home-to-local.enable = true;
  my.backup.home-to-ranni.enable = true;
  my.backup.home-to-rnet.enable = true;
  my.backup.srv-to-ranni = {
    enable = true;
    paths = [
      "/srv/freshrss"
      "/srv/home-assistant"
      "/srv/znc"
      "/var/backup"
      "/var/lib/private/invidious"
    ];
  };
  my.home-network-only.enable = true;

  networking = {
    hostName = "futaba";
    firewall = {
      allowedTCPPorts = [ 80 443 1883 4533 8081 8089 8092 8384 8443 8448 8989 9090 41641 ];
      allowedUDPPorts = [ 5354 8448 ];
    };
  };

  hardware.bluetooth.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  system.stateVersion = "24.05";
}
