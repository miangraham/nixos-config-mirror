{ config, lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
    ./twitter.nix
    ./services.nix
  ];

  networking = {
    hostName = "nene";
    interfaces.enp5s0.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 80 443 2222 8384 8443 8989 ];
    # nameservers = [ "192.168.0.128" ];
  };

  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    # "fs.inotify.max_user_instances" = 4096;
    # "net.ipv4.tcp_fin_timeout" = 10;
  };

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.!card "USB";
      defaults.ctl.!card "USB";
    '';
  };

  programs.steam.enable = true;

  system.stateVersion = "20.03";
}
