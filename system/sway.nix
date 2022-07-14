{ pkgs, lib, ... }:
{
  programs.sway = {
    enable = true;
  };
  xdg.portal.enable = true;
}
