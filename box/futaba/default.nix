{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ./services.nix
    ./containers.nix
  ];

  hardware.bluetooth.enable = true;

  system.stateVersion = "23.11";
}
