{ pkgs, inputs, ... }:
let
  inherit (import ../../system/backup-utils.nix {
    inherit pkgs;
    backupTime = "*-*-* *:10:00";
  }) job;
  nix = import ../../common/nix-settings.nix { inherit pkgs; };
  sshAuthKeys = import ../../common/ssh-auth-keys.nix {};
in
{
  inherit nix;

  networking = {
    hostName = "pika";
    useDHCP = true;
  };
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    i2c1.enable = true;
  };

  environment.systemPackages = import ./packages.nix { inherit pkgs; };

  boot = {
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };
    kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_6;
    kernelParams = [
      "8250.nr_uarts=1"
    ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  };

  users.users.ian = {
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
    openssh.authorizedKeys.keys = sshAuthKeys;
  };

  users.groups = {
    gpio = {};
    spi = {};
    storage = {};
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  services = {
    udisks2.enable = true;
    openssh = {
      enable = true;
      settings = {
        Macs = [
          "hmac-sha2-512"
          "hmac-sha2-256"
        ];
        PermitRootLogin = "no";
      };
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
      pkgs.udiskie
      pkgs.xdg_utils
    ];
    script = "udiskie -aNT";
  };

  security.polkit.extraConfig = ''
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

  programs = {
    dconf.enable = true;

    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        safe.directory = "/home/ian/.nix";
      };
    };

    nano = {
      nanorc = ''
        set nowrap
        set tabstospaces
        set tabsize 2
      '';
    };
  };

  system.stateVersion = "23.11";
}
