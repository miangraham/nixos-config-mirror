{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./containers.nix
  ];

  my.backup.home-to-local.enable = true;
  my.backup.home-to-ranni.enable = true;
  my.backup.srv-to-ranni = {
    enable = true;
    paths = [
      "/etc/dendrite"
      "/srv"
      "/var/backup"
      "/var/lib/gotosocial"
      "/var/lib/minecraft"
      "/var/lib/nextcloud"
      "/var/lib/private/dendrite"
      "/var/lib/private/wastebin"
      "/var/lib/thelounge"
      "/var/lib/wastebin"
    ];
  };
  my.home-network-only.enable = true;
  my.nebula-node.enable = true;

  networking = {
    hostName = "fuuka";
    firewall = {
      allowedTCPPorts = [ 80 443 7575 8008 8088 8384 9000 ];
      allowedUDPPorts = [ 8008 ];
    };
  };

  services.nebula.networks.asgard.firewall.inbound = [
    { port = 7575; proto = "tcp"; host = "any"; } # homepage
  ];

  boot.blacklistedKernelModules = [ "ite_cir" "iwlwifi" ];

  powerManagement = {
    cpuFreqGovernor = "conservative";
    powertop.enable = true;
  };

  system.stateVersion = "24.05";
}
