{ pkgs, config, inputs, modulesPath, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
    ./hardware-configuration.nix
  ];

  my.audio.enable = true;
  my.desktop.enable = true;
  my.nebula-node.enable = true;

  # time.timeZone = pkgs.lib.mkForce "Asia/Tokyo";

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
10.10.10.117 ranni
10.10.10.119 pika
10.10.10.120 boxypi
10.10.10.127 fuuka
10.10.10.128 futaba
10.10.10.128 invid
10.10.10.128 freshrss
10.10.10.132 nene
10.10.10.167 bocchi
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
    zotero
  ];

  services = {
    inherit borgbackup;
    # Okinawa is not China
    automatic-timezoned.enable = false;
    rabbitmq.enable = false;
    redis.servers.dev = {
      enable = false;
      port = 6379;
    };
  };

  system.stateVersion = "24.05";
}
