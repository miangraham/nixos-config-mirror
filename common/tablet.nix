{ pkgs, config, ... }:
let
  fonts = import ../system/fonts.nix { inherit pkgs; };
in
{
  inherit fonts;

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = [ pkgs.fcitx5-mozc ];
  # };

  environment = {
    systemPackages = with pkgs; [
    ];
    variables = {
    };
  };

  programs = {
  };

  hardware.opengl.enable = true;
  security.rtkit.enable = true;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  home-manager.users.ian.programs.plasma.enable = true;
}
