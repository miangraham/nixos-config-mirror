{ pkgs, inputs, ... }:
{
  imports = [
    ./containers.nix
    ./services.nix
    ../../system/base.nix
    ../../system/network.nix
  ];

  networking = {
    hostName = "pika";
    useDHCP = pkgs.lib.mkForce true;
    firewall.allowedTCPPorts = [ 3001 ];
  };

  powerManagement.cpuFreqGovernor = "conservative";
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
    # Disable wifi
    blacklistedKernelModules = [ "brcmfmac" ];
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

  system.stateVersion = "23.11";
}
