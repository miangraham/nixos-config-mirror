{ config, pkgs, lib, ... }:
{
  imports = [
    ../../system/darwin.nix
  ];
  system.stateVersion = 4;
  networking.hostName = "maho";
}
