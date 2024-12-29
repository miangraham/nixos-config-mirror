{ pkgs, inputs, ... }:
{
  imports = [
    ../../system/pi5.nix
  ];

  my.desktop.enable = true;
  my.home-network-only.enable = true;
  my.nebula-node.enable = false;

  networking = {
    hostName = "mugi";
    firewall.allowedTCPPorts = [];
  };

  system.stateVersion = "24.11";
}
