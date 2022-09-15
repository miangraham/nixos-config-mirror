{ inputs, ... }: { pkgs, config, ... }:
let
  lib = pkgs.lib;
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  dev = import ../common/dev.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs inputs unstable; };

  alacritty = import ./alacritty.nix { inherit pkgs; };
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  firefox = import ./firefox.nix { inherit pkgs; };
  git = import ./git.nix { pkgs = unstable; };
  mpv = import ./mpv.nix { inherit pkgs; };
  secrets = import ./secrets.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  sworkstyle = dev.swayest-workstyle;
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

    # home-manager.enable = true;
    autojump.enable = true;
    feh.enable = true;

    # obs-studio = {
    #   enable = true;
    #   plugins = [ pkgs.obs-studio-plugins.obs-websocket ];
    # };

    rofi = {
      enable = false;
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

    mako = {
      enable = true;
      maxVisible = 1;
      defaultTimeout = 10000;
      ignoreTimeout = true;
      actions = false;
      anchor = "top-right";
      # margin = "20,20,100,20"; # top right bottom left
      margin = "20"; # top right bottom left
      width = 500;
      height = 500;
      borderSize = 0;
      backgroundColor = "#68217AFF";
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
      enable = false;
      timeouts = [{
        timeout = 600;
        command = "swaymsg \"output * dpms off\"";
        resumeCommand = "swaymsg \"output * dpms on\"";
      }];
    };
  };

  systemd.user = {
    targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    services.fcitx-daemon = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "/run/current-system/sw/bin/fcitx -D";
    };

    services.sworkstyle = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${sworkstyle}/bin/sworkstyle -d";
    };

    services.autotiling = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.autotiling}/bin/autotiling";
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/.config/dummyxdgdesktop";
    documents = "$HOME/documents";
    download = "$HOME/downloads";
    music = "$HOME/music";
    pictures = "$HOME/pictures";
    publicShare = "$HOME/.config/dummyxdgpublicshare";
    templates = "$HOME/.config/dummyxdgtemplates";
    videos = "$HOME/videos";
  };
}
