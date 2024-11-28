{ pkgs, config, inputs, modulesPath, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.starlabs-starlite-i5
    ./hardware-configuration.nix
  ];

  my.audio.enable = true;
  my.nebula-node.enable = true;
  my.tablet.enable = true;

  # time.timeZone = pkgs.lib.mkForce "Asia/Tokyo";

  networking = {
    hostName = "ema";
    networkmanager.enable = true;
    resolvconf.dnsExtensionMechanism = false;
    firewall.allowedTCPPorts = [ 22 8443 41641 ];
     extraHosts = pkgs.lib.mkForce ''
10.10.10.117 ranni
10.10.10.119 pika
10.10.10.120 boxypi
10.10.10.123 ema
10.10.10.127 fuuka
10.10.10.128 futaba
10.10.10.128 invid
10.10.10.128 freshrss
10.10.10.132 nene
10.10.10.133 rin
10.10.10.167 bocchi
'';
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
    krita
  ];

  system.stateVersion = "24.05";
}
