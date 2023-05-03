{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./storage.nix
    ./services.nix
  ];

  networking = {
    hostName = "ranni";
    hostId = "cd1da50a";
    interfaces.enp9s0f1np0.useDHCP = true;
    interfaces.enp9s0f1np1.useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 4533 8081 8089 8384 8443 8989 9090 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  users = {
    users.timemachine = {
      description = "Time Machine backups";
      group = "timemachine";
      isSystemUser = true;
    };
    groups.timemachine = {};

    users.borg = {
      description = "Borg backups";
      group = "borg";
      isNormalUser = true;
      home = "/srv/borg";
      openssh.authorizedKeys.keys = config.users.users.ian.openssh.authorizedKeys.keys;
    };
    groups.borg = {};
  };

  # TODO: Make these a mixin component instead of turning off here
  security.rtkit.enable = pkgs.lib.mkForce false;
  home-manager.users.ian.services.playerctld.enable = pkgs.lib.mkForce false;

  system.stateVersion = "22.11";
}
