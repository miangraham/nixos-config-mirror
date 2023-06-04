{ pkgs, config, modulesPath, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
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
    extensions = with pkgs.vscode-extensions; [
      mskelton.one-dark-theme
      rust-lang.rust-analyzer
      tuttieee.emacs-mcx
    ];
  };

  services = {
    inherit borgbackup;
    fwupd.enable = true;
  };

  system.stateVersion = "23.05";
}
