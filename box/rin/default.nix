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

  # Power
  powerManagement.powertop.enable = true;
  programs.light.enable = true;
  services.upower.enable = true;

  # BT
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.steam.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
  ];

  home-manager.users.ian.programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      mskelton.one-dark-theme
      rust-lang.rust-analyzer
      tuttieee.emacs-mcx
    ];
  };

  services = {
    inherit borgbackup;

    nebula.networks.asgard = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/rin.crt";
      key = "/etc/nebula/rin.key";
      lighthouses = [ "192.168.100.128" ];
      relays = [ "192.168.100.128" ];
      staticHostMap = {
        "192.168.100.128" = [
          "192.168.0.128:4242"
          "122.249.92.87:4242"
        ];
      };
      firewall = {
        inbound = [
          { port = "any"; proto = "icmp"; host = "any"; }
        ];
        outbound =  [ { port = "any"; proto = "any"; host = "any"; } ];
      };
      settings.preferred_ranges = [ "192.168.0.0/24" ];
    };
  };

  system.stateVersion = "23.05";
}
