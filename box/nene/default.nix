{ config, lib, modulesPath, inputs, pkgs, ... }:
let
  obs-customized = pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ]; };
  texlive-customized = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      beamer
      collection-latexextra
      koma-script
      scheme-small

      noto
      mweights
      cm-super
      cmbright
      fontaxes
      beamertheme-metropolis
      collection-langjapanese
      collection-langchinese
    ;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/nebula-node.nix
    ../../common/desktop.nix
    ../../common/audio.nix
    ./network.nix
    ./services.nix
    ./containers.nix
  ];

  # 6.6 LTS
  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    "net.ipv4.tcp_fin_timeout" = 10;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    carla
    element-desktop # electron
    esphome
    # gimp
    kdenlive
    # libreoffice
    lsp-plugins
    mame.tools
    obs-customized
    ollama
    # picocom
    # signal-desktop # unused
    playerctl
    reaper
    sonixd
    soundconverter
    tap-plugins
    texlive-customized
    # twitch-tui
    zotero
  ];

  # home-manager.users.ian.programs.ssh.matchBlocks.nano = {
  #   hostname = "nano";
  #   localForwards = [{
  #     bind.port = 5900;
  #     host.address = "127.0.0.1";
  #     host.port = 5900;
  #   }];
  # };

  system.stateVersion = "23.11";
}
