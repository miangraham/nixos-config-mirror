{ pkgs, config, modulesPath, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../common/desktop.nix
  ];

  networking = {
    hostName = "rin";
    networkmanager.enable = true;
    resolvconf.dnsExtensionMechanism = false;
    firewall.allowedTCPPorts = [ 22 8443 41641 ];
    interfaces = {
      enp2s0f0.useDHCP = true;
      enp5s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Boot
  boot.kernelParams = [
    "usbcore.autosuspend=120"
  ];

  # Power
  powerManagement.powertop.enable = true;
  programs.light.enable = true;
  services.upower.enable = true;

  # BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.steam.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
    tpacpi-bat
  ];

  services = {
    inherit borgbackup;
    rabbitmq.enable = true;
    redis.servers.dev = {
      enable = true;
      port = 6379;
    };
  };

  system.stateVersion = "23.11";
}
