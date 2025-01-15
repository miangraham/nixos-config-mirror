{ pkgs, config, inputs, modulesPath, ... }:
let
  displayId = "eDP-1";
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-pocket-4
    ./hardware-configuration.nix
  ];

  my.audio.enable = true;
  my.desktop.enable = true;
  my.gaming.enable = true;

  networking = {
    hostName = "yuuri";
    firewall.allowedTCPPorts = [ 22 8443 41641 ];
    networkmanager.enable = true;
  };

  programs.light.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.ian.wayland.windowManager.sway.config = {
    output.${displayId}.transform = "90";
    input."type:touch".map_to_output = displayId;
  };

  # LUKS encrypted
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "ian";
    };
  };

  system.stateVersion = "24.11";
}
