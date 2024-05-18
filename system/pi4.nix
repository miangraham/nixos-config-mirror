{ pkgs, inputs, ... }:
{
  networking.useDHCP = pkgs.lib.mkForce true;

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
    kernelParams = [
      "8250.nr_uarts=1"
      "cgroup_enable=memory"
    ];
    initrd.availableKernelModules = [ "usbhid" ];
    # Disable wifi
    blacklistedKernelModules = [ "brcmfmac" ];
  };

  users.groups = {
    gpio = {};
    spi = {};
    storage = {};
  };

  home-manager.users.ian.home.packages = with pkgs; [
    emacs29-nox
    libraspberrypi
    raspberrypi-eeprom
  ];
}
