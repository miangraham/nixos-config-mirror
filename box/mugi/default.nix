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

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  system.stateVersion = "24.11";
}
