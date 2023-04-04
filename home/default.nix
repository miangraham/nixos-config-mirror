{ inputs, system, ... }: { pkgs, config, ... }:
let
  lib = pkgs.lib;
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs inputs unstable system; };
  accounts = import ./accounts.nix { inherit pkgs; };

  alacritty = import ./alacritty.nix { inherit pkgs; };
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  firefox = import ./firefox.nix { inherit pkgs; };
  git = import ./git.nix { inherit pkgs; };
  kitty = import ./kitty.nix { inherit pkgs; };
  mpv = import ./mpv.nix { inherit pkgs; };
  secrets = import ./secrets.nix { inherit pkgs; };
  ssh = import ./ssh.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  sworkstyle = pkgs.swayest-workstyle;
  tmux = import ./tmux.nix { inherit pkgs; };
  waybar = import ./waybar.nix { inherit lib pkgs; };
in
{
  inherit accounts;
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
    inherit alacritty bash direnv firefox git kitty mpv ssh starship tmux waybar;
    inherit (secrets.programs) gpg password-store;

    autojump.enable = true;
    feh.enable = true;
    mbsync.enable = true;
    mu.enable = true;

    htop = {
      enable = true;
      settings = {
        sort_key = config.lib.htop.fields.PERCENT_CPU;
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
      };
    };

    swaylock.settings = {
      color = "3f3f3f";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };

  services = {
    inherit (secrets.services) gpg-agent;

    lorri.enable = true;
    kanshi.enable = true;
    playerctld.enable = true;

    udiskie = {
      enable = true;
      notify = false;
      tray = "never";
      settings = {
        device_config = [{
          device_file = "/org/freedesktop/UDisks2/block_devices/mmcblk0p1";
          ignore = true;
          automount = false;
        }];
      };
    };

    swayidle = {
      enable = false;
      timeouts = [{
        timeout = 600;
        command = "swaymsg \"output * dpms off\"";
        resumeCommand = "swaymsg \"output * dpms on\"";
      }];
    };

    dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          progress_bar = false;
          indicate_hidden = false;
          show_indicators = false;
          ignore_dbusclose = true;
          notification_limit = 5;
          timeout = "5s";
          min_icon_size = 64;
          max_icon_size = 64;
          corner_radius = 0;
          frame_width = 0;
          origin = "top-right";
          offset = "20x20";
          width = "(300, 800)";
          font = "Noto Sans 10";
          foreground = "#FFFFFFFF";
          background = "#68217AFF";
        };

        # Overrideable settings listed at https://github.com/dunst-project/dunst/blob/master/dunstrc#L346
        urgency_critical = {
          timeout = "60s";
          foreground = "#FFFFFFFF";
          background = "#F14949FF";
        };

        urgency_low = {
          timeout = "10s";
          foreground = "#FFFFFFFF";
          background = "#579C4CFF";
        };
      };
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

    # services.twitch-alerts = let
    #   twitch-alerts = inputs.twitch-alerts.packages.${system}.default;
    # in {
    #   Install.WantedBy = [ "graphical-session.target" ];
    #   Service = {
    #     ExecStart = "${twitch-alerts}/bin/twitch-alerts";
    #     EnvironmentFile = "/home/ian/.config/twitch-alerts/env";
    #     SyslogIdentifier="twitch-alerts";
    #     Restart = "always";
    #   };
    # };
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

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-www-browser" = "firefox.desktop";
      "x-www-browser" = "firefox.desktop";
      "x-scheme-handler/webcal" = "firefox.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-www-browser" = "firefox.desktop";
      "x-www-browser" = "firefox.desktop";
      "x-scheme-handler/webcal" = "firefox.desktop";
    };
  };

  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
    gtk.enable = true;
  };

  gtk = let
    t = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    ex = { gtk-application-prefer-dark-theme = true; };
  in {
    enable = true;
    theme = t;
    iconTheme = t;
    gtk3.extraConfig = ex;
    gtk4.extraConfig = ex;
  };

  qt = {
    enable = false;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
