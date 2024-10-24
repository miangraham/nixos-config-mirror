{ config, lib, modulesPath, inputs, pkgs, ... }:
let
  nix-search = inputs.nixsearch.packages.${pkgs.system}.default;
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
    ../../system/home-network-only.nix
    ../../system/nebula-node.nix
    ../../common/desktop.nix
    ../../common/audio.nix
    ./services.nix
    ./containers.nix
  ];

  networking = {
    hostName = "nene";
    firewall.allowedTCPPorts = [ 80 443 5672 6379 8443 41641 ];
  };

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

  programs.steam.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
    apksigner
    asunder
    carla
    element-desktop
    krita
    losslesscut-bin
    lsp-plugins
    mame.tools
    nix-search
    obs-customized
    playerctl
    reaper
    sonixd
    soundconverter
    tap-plugins
    texlive-customized
    yubikey-manager
    zotero
  ];

  system.stateVersion = "24.05";
}
