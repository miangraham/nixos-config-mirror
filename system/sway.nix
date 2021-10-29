{ lib, ... }:
let
  pkgs = import ../common/stable.nix {};
in
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
