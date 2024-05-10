{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ../../system/base.nix
    ../../system/network.nix
  ];

  networking = {
    hostName = "mika";
    useDHCP = pkgs.lib.mkForce true;
    firewall.allowedTCPPorts = [ ];
  };

  powerManagement.cpuFreqGovernor = "conservative";
  hardware = {
    deviceTree.enable = true;
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
    };
  };

  boot = {
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
      systemd-boot.enable = pkgs.lib.mkForce false;
      efi.canTouchEfiVariables = pkgs.lib.mkForce false;
    };
    kernelPackages = pkgs.lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    # kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_6;

    # Disable wifi
    blacklistedKernelModules = [ "brcmfmac" ];
  };

  users.groups = {
    gpio = {};
    spi = {};
    storage = {};
  };

  system.stateVersion = "23.11";
}
