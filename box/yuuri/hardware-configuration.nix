# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7d0ac7b0-6cef-4ceb-9680-89fd07d7970d";
      fsType = "btrfs";
      options = [ "noatime" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/e935110f-99bf-4a6a-b1ef-5b91cee61a1c";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B1C1-3C1E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/08149af0-a868-4f40-b364-12f853cd444e"; }
    ];

  boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/da905e4d-6f25-4d22-9da1-ff408080df11";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp196s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp195s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
