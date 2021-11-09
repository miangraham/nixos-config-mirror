{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
    ./services.nix
  ];

  networking = {
    hostName = "futaba";
    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 22 80 443 2222 53 8384 8443 8989 9090 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  nix = {
    binaryCaches = [
      "ssh://nene"
    ];
    binaryCachePublicKeys = [
      "nene-1:AAAAC3NzaC1lZDI1NTE5AAAAIPDpJxzKkHNfFMo0hZtFmsT1cC8wWOkjfUiRHn0E9Kek"
    ];
  };

  system.stateVersion = "21.05";
}
