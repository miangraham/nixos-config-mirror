{ config, ... }:
let
  pkgs = import ../../common/stable.nix {};
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
    ./services.nix
  ];
  system.stateVersion = "21.05";
  networking.hostName = "futaba";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.firewall.allowedTCPPorts = [ 22 23 80 443 2222 8384 8443 8989 9090 ];
}
