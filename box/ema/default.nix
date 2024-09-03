{ pkgs, config, modulesPath, ... }:
let
  # borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/nebula-node.nix
    ../../common/tablet.nix
    ../../common/audio.nix
  ];

  time.timeZone = pkgs.lib.mkForce "Europe/London";

  networking = {
    hostName = "ema";
    networkmanager.enable = true;
    resolvconf.dnsExtensionMechanism = false;
    firewall.allowedTCPPorts = [ 22 8443 41641 ];
     extraHosts = pkgs.lib.mkForce ''
192.168.100.117 ranni
192.168.100.119 pika
192.168.100.120 boxypi
192.168.100.123 ema
192.168.100.127 fuuka
192.168.100.128 futaba
192.168.100.128 invid
192.168.100.128 freshrss
192.168.100.132 nene
192.168.100.133 rin
192.168.100.167 bocchi
'';
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Power
  powerManagement.powertop.enable = true;
  programs.light.enable = true;
  services.upower.enable = true;

  # BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Tablet
  hardware.sensor.iio.enable = true;
  services.udev.extraHwdb = ''
    sensor:modalias:acpi:KIOX000A*:dmi:*:*
      ACCEL_MOUNT_MATRIX=1, 0, 0; 0, -1, 0; 0, 0, 1
  '';

  home-manager.users.ian.home.packages = with pkgs; [
    krita
  ];

  system.stateVersion = "24.05";
}
