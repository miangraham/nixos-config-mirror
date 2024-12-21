{ pkgs, inputs, ... }:
{
  imports = [
    ../../system/pi5.nix
  ];

  my.home-network-only.enable = true;
  my.nebula-node.enable = false;

  networking = {
    hostName = "chaika";
    firewall.allowedTCPPorts = [];
  };

  system.stateVersion = "24.11";
}
