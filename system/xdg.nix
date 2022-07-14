{ pkgs, ... }:
{
  environment.variables.XDG_DESKTOP_DIR = "/dev/null";
  programs.sway.enable = true;
  xdg.portal.enable = true;
}
