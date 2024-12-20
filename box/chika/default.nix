{ pkgs, inputs, ... }:
{
  imports = [
    ../../system/pi5.nix
  ];

  my.home-network-only.enable = true;
  my.nebula-node.enable = false;

  networking = {
    hostName = "chika";
    firewall.allowedTCPPorts = [ 3001 ];
  };

  users.users.root.initialPassword = "root";
  users.users.ian.initialPassword = "ian";

  system.stateVersion = "24.11";
}
