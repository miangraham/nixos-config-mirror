# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "uas" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5d137954-3281-41f8-ac3a-ba2a3e9aa39f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/27BD-5A61";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/5daa30f4-99ac-4a94-95c9-0ecb0feb0fb4"; }
    ];

  nix.settings.max-jobs = lib.mkDefault 32;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
