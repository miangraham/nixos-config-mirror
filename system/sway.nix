{ pkgs, lib, ... }:
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      waybar
    ];
  };
  xdg.portal.enable = true;
}
