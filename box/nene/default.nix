{ config, lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ./services.nix
    ./php.nix
  ];

  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    "fs.inotify.max_user_instances" = 4096;
    "net.ipv4.tcp_fin_timeout" = 10;
  };

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.!card "USB";
      defaults.ctl.!card "USB";
    '';
  };

  services.udev.packages = [ pkgs.via pkgs.qmk-udev-rules ];

  programs.steam.enable = true;

  virtualisation.docker = {
    # enable = true;
    rootless = {
      enable = false;
      setSocketVariable = true;
    };
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
    asunder
    gimp
    guestfs-tools
    libreoffice
    picocom
    twitch-tui
    virt-manager
  ];

  system.stateVersion = "20.03";
}
