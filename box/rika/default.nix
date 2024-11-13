{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ../../system/pi4.nix
  ];

  hardware.raspberry-pi."4".pwm0.enable = true;

  networking = {
    hostName = "rika";
    firewall.allowedTCPPorts = [ 6443 8472 10250 ];
  };

  environment.systemPackages = [ pkgs.k3s ];

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "/srv/k3s/token";
    serverAddr = "https://mika:6443";
  };

  system.stateVersion = "24.05";
}
