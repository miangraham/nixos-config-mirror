{ pkgs, inputs, ... }:
let
  unstable-small = import ../../common/unstable-small.nix { inherit pkgs inputs; };
  inherit (import ../../system/backup-shared.nix {
    pkgs = unstable-small;
    backupTime = "*-*-* *:10:00";
  }) job;
in
{
  networking = {
    hostName = "pika";
  };

  time.timeZone = "Asia/Tokyo";

  nixpkgs.config.allowUnfree = true;

  boot = {
    tmpOnTmpfs = true;
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
        uboot.enable = true;
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.raspberry-pi."4".i2c1.enable = true;
  hardware.deviceTree.overlays = [{
    name = "spi-okay-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
          target = <&spi>;
          __overlay__ {
            status = "okay";
          };
        };
      };
    '';
  } {
    name = "gpio-ir-pin-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
                target-path = "/";
                __overlay__ {
                        gpio_ir: ir-receiver@12 {
                                compatible = "gpio-ir-receiver";
                                pinctrl-names = "default";
                                pinctrl-0 = <&gpio_ir_pins>;

                                // pin number, high or low
                                gpios = <&gpio 21 1>;

                                // parameter for keymap name
                                linux,rc-map-name = "rc-rc6-mce";

                                status = "okay";
                        };
                };
        };
        fragment@1 {
                target = <&gpio>;
                __overlay__ {
                        gpio_ir_pins: gpio_ir_pins@12 {
                                brcm,pins = <21>;                       // pin 18
                                brcm,function = <0>;                    // in
                                brcm,pull = <2>;                        // up
                        };
                };
        };
      };
    '';
  }];

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
          "i2c"
          "networkmanager"
          "spi"
          "storage"
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
    groups.spi = {};
    groups.storage = {};
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  environment.systemPackages = import ./packages.nix { pkgs = unstable-small; };

  services = {
    earlyoom.enable = true;
    openssh = {
      enable = true;
      permitRootLogin = "no";
    };
    udev.extraRules = ''
      SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
      SUBSYSTEM=="gpio", GROUP="gpio", MODE="0660"
      SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${unstable-small.bash}/bin/bash -c 'chgrp -R gpio /sys/class/gpio ; chmod -R g=u /sys/class/gpio ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
      SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${unstable-small.bash}/bin/bash -c 'chgrp -R gpio /sys%p && chmod -R g=u /sys%p'"

      SUBSYSTEM=="spidev", GROUP="spi", MODE="0660"
  '';
    udisks2 = {
      enable = true;
    };
    borgbackup.jobs.home-ian-to-usb = job {
      repo = "/run/media/ian/70F8-1012/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };
  };

  systemd.services.udiskie = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      unstable-small.udiskie
      unstable-small.xdg_utils
    ];
    script = "udiskie -aNT";
  };

  security.polkit = {
    extraConfig = ''
polkit.addRule(function(action, subject) {
  var YES = polkit.Result.YES;
  var permission = {
    // required for udisks1:
    "org.freedesktop.udisks.filesystem-mount": YES,
    "org.freedesktop.udisks.luks-unlock": YES,
    "org.freedesktop.udisks.drive-eject": YES,
    "org.freedesktop.udisks.drive-detach": YES,
    // required for udisks2:
    "org.freedesktop.udisks2.filesystem-mount": YES,
    "org.freedesktop.udisks2.encrypted-unlock": YES,
    "org.freedesktop.udisks2.eject-media": YES,
    "org.freedesktop.udisks2.power-off-drive": YES,
    // required for udisks2 if using udiskie from another seat (e.g. systemd):
    "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
    "org.freedesktop.udisks2.filesystem-unmount-others": YES,
    "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
    "org.freedesktop.udisks2.eject-media-other-seat": YES,
    "org.freedesktop.udisks2.power-off-drive-other-seat": YES
  };
  if (subject.isInGroup("storage")) {
    return permission[action.id];
  }
});
    '';
  };

  system.stateVersion = "21.11";
}
