{ config, lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/nebula-node.nix
    ../../common/desktop.nix
    ./network.nix
    ./services.nix
    ./containers.nix
  ];

  # 6.6 LTS
  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    "net.ipv4.tcp_fin_timeout" = 10;
  };

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.!card "USB";
      defaults.ctl.!card "USB";
    '';
  };

  services.udev.packages = [
    # pkgs.via
    # pkgs.qmk-udev-rules
  ];

  programs.steam.enable = false;

  # virtualisation = {
  #   libvirtd.enable = true;
  #   spiceUSBRedirection.enable = true;
  # };

  home-manager.users.ian.home.packages = with pkgs; [
    apksigner
    asunder
    # element-desktop # electron
    gimp
    libreoffice
    mame.tools
    picocom
    # signal-desktop # unused
    twitch-tui
  ];

  system.stateVersion = "23.11";
}
