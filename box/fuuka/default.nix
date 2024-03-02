{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ./services.nix
    ./containers.nix
  ];

  system.stateVersion = "23.11";
}
