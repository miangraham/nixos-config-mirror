{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ../../system/pi4.nix
  ];

  hardware.raspberry-pi."4".pwm0.enable = true;

  networking = {
    hostName = "mika";
    firewall.allowedTCPPorts = [ 6443 8472 ];
  };

  environment.systemPackages = [ pkgs.k3s ];

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/srv/k3s/token";
    extraFlags = toString [
      "--disable metrics-server"
    ];
  };

  system.stateVersion = "24.05";
}
