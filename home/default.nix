{ inputs, ... }: { pkgs, ... }:
let
  lib = pkgs.lib;
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs unstable; };

  alacritty = import ./alacritty.nix { inherit pkgs; };
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  firefox = import ./firefox.nix { inherit unstable; };
  git = import ./git.nix { inherit pkgs; };
  mpv = import ./mpv.nix {};
  secrets = import ./secrets.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
  waybar = import ./waybar.nix { inherit lib pkgs; };
in
{
  home = {
    packages = home-packages;
    stateVersion = "21.05";
    username = "ian";
    homeDirectory = "/home/ian";
  };

  programs = {
    inherit alacritty bash direnv firefox git mpv starship tmux waybar;
    inherit (secrets.programs) gpg password-store;

    home-manager.enable = true;
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
