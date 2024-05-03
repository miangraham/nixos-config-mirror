{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ../../common/desktop.nix
  ];

  boot.blacklistedKernelModules = [ ];

  powerManagement = {
    cpuFreqGovernor = "schedutil";
    # powertop.enable = true;
  };

  # hardware.deviceTree = {
  #   name = "rockchip/rk3588s-nanopi-r6c.dtb";
  #   overlays = [];
  # };

  environment.variables = {
    WLR_BACKENDS = "headless";
    WLR_LIBINPUT_NO_DEVICES = "1";
  };

  system.stateVersion = "23.11";
}
