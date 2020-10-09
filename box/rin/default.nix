{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
  ];

  system.stateVersion = "20.03";

  networking.hostName = "rin";

  networking.networkmanager.enable = true;

  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  programs.light.enable = true;
  services.upower.enable = true;
  powerManagement.powertop.enable = true;
}
