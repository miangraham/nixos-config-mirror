{ lib, ... }:
let
  pkgs = import ../common/stable.nix {};
in
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      sway-contrib.inactive-windows-transparency
      swaylock
      swayidle
      xwayland
      waybar
    ];
  };
  programs.waybar.enable = true;
}
