{ pkgs, config, modulesPath, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/nebula-node.nix
    ../../common/desktop.nix
  ];

  time.timeZone = pkgs.lib.mkForce null;

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
    extraHosts = pkgs.lib.mkForce ''
192.168.100.117 ranni
192.168.100.119 pika
192.168.100.120 boxypi
192.168.100.127 fuuka
192.168.100.127 nextcloud
192.168.100.128 futaba
192.168.100.128 invid
192.168.100.128 freshrss
192.168.100.128 graham.tokyo
192.168.100.132 nene
192.168.100.155 tinypi
192.168.100.167 bocchi
'';
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
    element-desktop
    tpacpi-bat
  ];

  services = {
    inherit borgbackup;
    automatic-timezoned.enable = true;
    rabbitmq.enable = false;
    redis.servers.dev = {
      enable = false;
      port = 6379;
    };
  };

  system.stateVersion = "23.11";
}
