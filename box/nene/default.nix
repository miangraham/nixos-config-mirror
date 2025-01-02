{ config, lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./containers.nix
  ];

  my.audio.enable = true;
  my.backup.home-to-local.enable = true;
  my.backup.home-to-ranni.enable = true;
  my.backup.home-to-rnet.enable = true;
  my.backup.home-to-usb = {
    enable = true;
    repo = "/run/media/ian/70F3-5B2F/borg";
  };
  my.desktop.enable = true;
  my.gaming.enable = true;
  my.home-network-only.enable = true;
  my.nebula-node.enable = true;
  my.streaming.enable = true;

  networking = {
    hostName = "nene";
    firewall.allowedTCPPorts = [ 80 443 5672 6379 8443 41641 ];
  };

  # boot.kernel.sysctl = {
  #   "fs.file-max" = 9000000;
  #   "net.ipv4.tcp_fin_timeout" = 10;
  # };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # temp, system locked on 2024-12-08. bios?
  systemd.oomd = {
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  home-manager.users.ian.home.packages = with pkgs; [
    element-desktop # webkit
    gthumb # quick image cropping # qtwebengine
    kiwix # qtwebengine
    krita # opencv      # element-desktop # webkit
    nomacs # opencv build
    remmina # freerdp
    yubikey-manager
    zeal # qtwebengine build

    losslesscut-bin # x86 only
    sonixd # x86 only
    zotero # x86 only

    (pkgs.texlive.combine {
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
    })
  ];

  home-manager.users.ian.services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 7200;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }];
  };

  programs.virt-manager.enable = true;

  # TODO: move tweaks into shared module somehow
  systemd.services.borgbackup-job-home-ian-to-ranni = {
    startLimitBurst = 3;
    startLimitIntervalSec = 120;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
  systemd.services.borgbackup-job-home-ian-to-rnet = {
    startLimitBurst = 3;
    startLimitIntervalSec = 120;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  system.stateVersion = "24.05";
}
