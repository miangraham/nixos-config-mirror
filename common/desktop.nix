{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./hyprland.nix
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-wlr
  ];

  programs = {
    adb.enable = true;
    sway.enable = true;
    wshowkeys.enable = true;
  };

  xdg.portal.enable = true;

  home-manager.users.ian.wayland.windowManager.sway.enable = true;
}
