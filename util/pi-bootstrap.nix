{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    # tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  nix = {
    package = pkgs.nix_2_4;
    allowedUsers = ["@wheel" "nix-ssh"];
    trustedUsers = ["@wheel"];
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ="
    ];
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "pika";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    emacs
    git
    nano
  ];

  users = {
    users = {
      ian = {
        isNormalUser = true;
        extraGroups = [ "audio" "dialout" "networkmanager" "wheel" "video" ];
        openssh.authorizedKeys.keys = [];
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  services.openssh.enable = true;
  time.timeZone = "Asia/Tokyo";
  system.stateVersion = "21.11";
}
