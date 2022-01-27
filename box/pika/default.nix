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
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
    # loader = {
    #   raspberryPi = {
    #     enable = true;
    #     version = 4;
    #     # uboot.enable = true;
    #   };
    # };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.raspberry-pi."4".i2c1.enable = true;
  hardware.deviceTree.overlays = [{
    name = "sd-poll-once-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
          target = <&emmc2>;
          __overlay__ {
            non-removable;
          };
        };
      };
    '';
  } {
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
  }];
  # {
  #   name = "gpio-ir-pin-overlay";
  #   dtsText = ''
  #     /dts-v1/;
  #     /plugin/;
  #     / {
  #       compatible = "brcm,bcm2711";
  #       fragment@0 {
  #         target-path = "/";
  #         __overlay__ {
  #           gpio_ir: ir-receiver@12 {
  #             compatible = "gpio-ir-receiver";
  #             pinctrl-names = "default";
  #             pinctrl-0 = <&gpio_ir_pins>;

  #             // pin number, high or low
  #             gpios = <&gpio 21 1>;

  #             // parameter for keymap name
  #             linux,rc-map-name = "rc-rc6-mce";

  #             status = "okay";
  #           };
  #         };
  #       };
  #       fragment@1 {
  #         target = <&gpio>;
  #         __overlay__ {
  #           gpio_ir_pins: gpio_ir_pins@12 {
  #             brcm,pins = <21>;                       // pin 18
  #             brcm,function = <0>;                    // in
  #             brcm,pull = <2>;                        // up
  #           };
  #         };
  #       };
  #     };
  #   '';
  # }
  #  {
  #   name = "gpio-ir-tx-pin-overlay";
  #   dtsText = ''
  #     /dts-v1/;
  #     /plugin/;
  #     / {
  #       compatible = "brcm,bcm2711";
  #       fragment@0 {
  #         target-path = "/";
  #         __overlay__ {
  #           gpio_ir_tx: gpio-ir-transmitter@12 {
  #             compatible = "gpio-ir-tx";
  #             pinctrl-names = "default";
  #             pinctrl-0 = <&gpio_ir_tx_pins>;
  #             gpios = <&gpio 20 0>;
  #           };
  #         };
  #       };
  #       fragment@1 {
  #         target = <&gpio>;
  #         __overlay__ {
  #           gpio_ir_tx_pins: gpio_ir_tx_pins@12 {
  #             brcm,pins = <20>;
  #             brcm,function = <1>;  // out
  #           };
  #         };
  #       };
  #     };
  #   '';
  # }

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
          "lirc"
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

      SUBSYSTEM=="lirc", GROUP="lirc", MODE="0660"
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
    # lirc = {
    #   enable = false;
    #   options = ''
    #     [lircd]
    #     device=/dev/lirc0
    #   '';
    #   configs = [];
    # };
  };
#       configs = [''
# begin remote

#   name  Panasonic
#   bits           24
#   flags SPACE_ENC
#   eps            25
#   aeps          100

#   header       3555  1595
#   one           508   330
#   zero          508  1208
#   ptrail        508
#   pre_data_bits   24
#   pre_data       0xBFFBF6
#   gap          74464
#   toggle_bit      0


#       begin codes
#           KEY_POWER                0x0000000000FF434A        #  Was: power
#           KEY_RECORD               0x0000000000FFEFE6        #  Was: rec
#           KEY_UP                   0x0000000000FFD3DA        #  Was: up
#           KEY_DOWN                 0x0000000000FF535A        #  Was: down
#           KEY_PLAY                 0x0000000000FFAFA6        #  Was: play
#           KEY_STOP                 0x0000000000FFFFF6        #  Was: stop
#           KEY_PREVIOUS             0x0000000000FFBFB6        #  Was: prev
#           KEY_NEXT                 0x0000000000FF3F36        #  Was: next
#           pause/slow               0x0000000000FF9F96
#           KEY_SEARCH               0x00000000007F46CF        #  Was: search
#           index/prev               0x0000000000FF6D64
#           index/next               0x0000000000FFADA4
#           display                  0x00000000007F058C
#           reset                    0x0000000000FFD5DC
#           KEY_MENU                 0x00000000007F951C        #  Was: menu
#           KEY_ENTER                0x00000000007FE56C        #  Was: enter
#           vcr/tv                   0x0000000000FF939A
#           any1                     0x0000000000FF333A
#           program/check            0x00000000007F7FF6
#           KEY_CANCEL               0x00000000007F6FE6        #  Was: cancel
#           any2                     0x00000000007FAF26
#           timer_rec                0x0000000000FFD2DB
#           KEY_CHANNELUP            0x00000000007FF67F        #  Was: ch/up
#           KEY_CHANNELDOWN          0x00000000007F76FF        #  Was: ch/down
#           date/+                   0x00000000007FB63F
#           date/-                   0x00000000007F36BF
#           KEY_POWER                0x00000000007FD65F        #  Was: on/+
#           KEY_POWER                0x00000000007F56DF        #  Was: on/-
#           off/+                    0x00000000007F961F
#           off/-                    0x00000000007F169F
#       end codes

# end remote
#     ''];
#       configs = [''
# begin remote
#   name panasonicac
#   flags RAW_CODES
#   begin raw_codes
#     name OFF
#      3518     1718      451      389      453     1311
#       452      392      450      417      452      417
#       452      416      452      416      453      414
#       452      416      451      417      451      417
#       452      416      477      391      452     1312
#       452      390      452      419      450      416
#       452      416      452      416      463      405
#       454      414      452     1311      426     1313
#       424     1311      426      418      452      416
#       454     1308      426      418      475      393
#       476      392      478      391      475      393
#       476      392      476      393      476      394
#       475      392      478      391      478      390
#       479      390      480      388      480      389
#       480      388      481      387      480      389
#       479      388      481      387      481      387
#       481      387      482      386      482      387
#       481      387      480      388      481      388
#       482      386      480      388      479      388
#       477      391      451     1310      426     1310
#       428      419      451      418      449      419
#       448      420      448      421      450    10004
#      3474     1741      428      419      452     1306
#       430      418      449      420      449      420
#       452      416      449      420      450      418
#       450      418      450      417      450      418
#       450      418      450      418      448     1312
#       453      393      450      418      449      419
#       448      422      447      420      449      419
#       447      420      450     1312      458     1278
#       430     1307      429      441      425      443
#       426     1309      431      440      426      443
#       427      441      426      442      426      442
#       427      441      427      441      428      440
#       426      443      426      443      427      440
#       428      440      431      438      429      439
#       429      440      427      440      428      441
#       450      417      429      441      427     1305
#       435      438      451      417      429     1304
#       431     1307      432     1307      453      395
#       450     1306      430      420      446      421
#       449      419      448      420      448      420
#       450      418      448      420      447      421
#       447      421      448     1311      426     1309
#       428      422      448      420      446      423
#       445     1311      428     1312      426      422
#       446      422      446      422      445      424
#       444      423      444      424      444      424
#       443      426      445      444      422      445
#       424      447      421      446      421      450
#       419      447      419      449      413      455
#       413      455      415      453      413      455
#       413     1326      411     1328      410      455
#       413      455      414      454      413      457
#       411      456      413      455      413      456
#       413      455      415      455      411      455
#       412     1328      410     1329      409      456
#       412      455      413      455      414      454
#       413      455      413      455      413     1326
#       414      454      413      455      413      455
#       413      455      413      457      412      455
#       413      456      413      455      413      455
#       415      454      413      455      413      456
#       412      456      413      458      411      455
#       413      456      413      455      413     1327
#       411      455      413      455      412      456
#       413      456      414      454      412      456
#       413      455      413      456      413      457
#       411     1326      412     1325      415      454
#       413      456      412      456      412      457
#       412      458      411     1325      412      456
#       413      455      414      455      412     1325
#       412     1326      414      454      412      456
#       412    17912
#   end raw_codes
# end remote
#       ''];

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
