{ config, lib, ... }:
let
  pkgs = import ../common/stable.nix {};
  unstable = import ../common/unstable.nix {};
  home-packages = import ./packages.nix {};

  alacritty = import ./alacritty.nix {};
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  firefox = import ./firefox.nix {};
  git = import ./git.nix {};
  mpv = import ./mpv.nix {};
  secrets = import ./secrets.nix {};
  starship = import ./starship.nix {};
  tmux = import ./tmux.nix {};
  waybar = import ./waybar.nix { inherit config lib pkgs; };
in
{
  home.packages = home-packages;
  home.stateVersion = "21.05";
  home.username = "ian";
  home.homeDirectory = "/home/ian";

  programs = {
    inherit alacritty bash direnv firefox git mpv starship tmux waybar;
    inherit (secrets.programs) gpg password-store;

    feh.enable = true;

    obs-studio = {
      enable = true;
      package = unstable.obs-studio;
    };

    rofi = {
      enable = true;
      location = "bottom-right";
      width = 30;
      yoffset = -30;
      scrollbar = false;
      separator = "solid";
    };
  };

  services = {
    inherit (secrets.services) gpg-agent;

    lorri.enable = true;

    kanshi = {
      enable = true;
      package = pkgs.kanshi;
      extraConfig = ''
output "Ancor Communications Inc ROG PG279Q G1LMQS019376" mode 2560x1440 position 0,0
      '';
    };
  };
}
