{ pkgs, config, modulesPath, ... }:
let
  # Temporarily disable backup for travel
  # backup = import ../../system/backup.nix {
  #   inherit pkgs;
  #   backupTime = "*-*-* *:06:00";
  # };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
  ];

  networking = {
    hostName = "rin";
    networkmanager.enable = true;
    resolvconf.dnsExtensionMechanism = false;
    interfaces.enp2s0f0.useDHCP = true;
    interfaces.enp5s0.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 80 443 8443 8989 ];
  };

  programs.light.enable = true;
  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  services.fwupd.enable = true;
  services = {
    # inherit (backup) borgbackup;
  };

  # box specific due to ACME, rip
  services.nginx = {
    enable = false;
    user = "nginx";
    virtualHosts._ = {
      root = "/var/www";
    };
  };

  programs.steam.enable = true;

  system.stateVersion = "20.03";
}
