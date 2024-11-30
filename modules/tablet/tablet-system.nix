{ pkgs, config, inputs, ... }:
{
  my.fonts.enable = true;

  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  hardware.graphics.enable = true;
  security.rtkit.enable = true;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
}
