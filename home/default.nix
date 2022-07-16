{ inputs, ... }: { pkgs, config, ... }:
let
  lib = pkgs.lib;
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs inputs unstable; };

  alacritty = import ./alacritty.nix { inherit pkgs; };
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  firefox = import ./firefox.nix { inherit pkgs; };
  git = import ./git.nix { inherit pkgs; };
  mpv = import ./mpv.nix { inherit pkgs; };
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
    sessionPath = [
      "$HOME/.bin"
    ];
  };

  wayland.windowManager.sway = import ./sway.nix { inherit pkgs; };

  programs = {
    inherit alacritty bash direnv firefox git mpv starship tmux waybar;
    inherit (secrets.programs) gpg password-store;

    home-manager.enable = true;

    autojump.enable = true;
    feh.enable = true;
    obs-studio.enable = true;

    rofi = {
      enable = true;
      location = "bottom-right";
      yoffset = -30;
      theme = "gruvbox-dark";
    };

    htop = {
      enable = true;
      settings = {
        sort_key = config.lib.htop.fields.PERCENT_CPU;
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
      };
    };
  };

  services = {
    inherit (secrets.services) gpg-agent;

    lorri.enable = true;

    kanshi.enable = true;

    udiskie = {
      enable = true;
      notify = false;
      tray = "never";
    };

    swayidle = {
      enable = true;
      timeouts = [{
        timeout = 600;
        command = "swaymsg \"output * dpms off\"";
        resumeCommand = "swaymsg \"output * dpms on\"";
      }];
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
