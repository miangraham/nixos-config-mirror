{ pkgs, inputs, ... }:
let
  unstable-small = import ../../common/unstable-small.nix { inherit pkgs inputs; };
in
{
  networking = {
    hostName = "pika";
  };

  time.timeZone = "Asia/Tokyo";

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = unstable-small.linuxPackages_rpi4;
    tmpOnTmpfs = true;
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
    package = unstable-small.nix_2_4;
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

  users = {
    users = {
      ian = {
        isNormalUser = true;
        extraGroups = [
          "audio"
          "dialout"
          "gpio"
          "networkmanager"
          "video"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcbC9h0gXGiyRCKE4Pj8jJ4loQ89QyeG7m3H2hLm6Fc ian@futaba"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICD/gQKLw/+A7JQLLvX+pz7MS0g17hf3GHrzCmOaPUH1 ian@maho"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDJuEytWrkjLvzsiqisYAfdgDzk6SKf4e0u0OEqWJ9Y ian@nene"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtZ9GKY548o3w65T0HAQjULyuKthQzenZ36LO18brZo ian@rin"
        ];
      };
    };
    groups.gpio = {};
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware.enableRedistributableFirmware = true;

  powerManagement.cpuFreqGovernor = "ondemand";

  environment.systemPackages = import ./packages.nix { pkgs = unstable-small; };

  services = {
    openssh.enable = true;
    udev.extraRules = ''
      SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
      SUBSYSTEM=="gpio", GROUP="gpio", MODE="0660"
      SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${unstable-small.bash}/bin/bash -c 'chgrp -R gpio /sys/class/gpio ; chmod -R g=u /sys/class/gpio ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
      SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${unstable-small.bash}/bin/bash -c 'chgrp -R gpio /sys%p && chmod -R g=u /sys%p'"
  '';
  };

  system.stateVersion = "21.11";
}
