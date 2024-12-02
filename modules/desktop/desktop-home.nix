{ pkgs, config, inputs, ... }:
let
  inherit (pkgs) lib;

  alacritty = import ../../home/alacritty.nix { inherit pkgs; };
  firefox = import ../../home/firefox.nix { inherit pkgs; };
  kitty = import ../../home/kitty.nix { inherit pkgs; };
  mpv = import ../../home/mpv.nix { inherit pkgs; };
  waybar = import ./waybar.nix { inherit lib pkgs; };
in
{
  wayland.windowManager.sway = import ./sway.nix { inherit pkgs; };

  gtk = let
    t = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Dark-BL";
    };
    i = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };
    ex = { gtk-application-prefer-dark-theme = true; };
  in {
    enable = true;
    theme = t;
    iconTheme = i;
    gtk3.extraConfig = ex;
    gtk4.extraConfig = ex;
  };

  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
    gtk.enable = true;
  };

  home.packages = builtins.attrValues {
    emacs = inputs.emacspkg.packages.${pkgs.system}.default;
    nix-search = inputs.nixsearch.packages.${pkgs.system}.default;

    inherit (pkgs)
      adwaita-icon-theme
      # bitwarden # electron
      calf
      evince
      flameshot # custom screenshots
      fuzzel
      grim
      gthumb # quick image cropping
      kiwix
      krita
      # librewolf
      # nheko # libolm insecure
      nomacs
      okular
      qdirstat
      remmina
      slurp
      # ungoogled-chromium
      # vlc
      yubikey-manager
      zeal

      # sway
      swayidle
      swaylock
      libnotify
      waybar
      wev
      wl-clipboard
      wl-mirror
    ;

    # GUI bits
    inherit (pkgs.xfce) thunar;
  };

  programs = {
    inherit alacritty firefox kitty mpv waybar;

    feh.enable = true;

    bash.shellAliases.win = "sway";
    nushell.shellAliases.win = "sway";
    zsh.shellAliases.win = "sway";

    swaylock.settings = {
      color = "3f3f3f";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };

    chromium = {
      enable = true;
      package = pkgs.vivaldi;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # UBO
        { id = "jeoacafpbcihiomhlakheieifhpjdfeo"; } # Disconnect
        { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentralize
        { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsorblock
      ];
    };
  };

  services = {
    gnome-keyring.enable = true;
    kanshi.enable = true;
    playerctld.enable = true;

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
      Unit = {
        Requires = [ "sway-session.target" ];
        After = [ "sway-session.target" ];
      };
      Install.WantedBy = [ "sway-session.target" ];
      Service.ExecStart = "/run/current-system/sw/bin/fcitx5 -D";
    };

    services.sworkstyle = {
      Unit = {
        Requires = [ "sway-session.target" ];
        After = [ "sway-session.target" ];
      };
      Install.WantedBy = [ "sway-session.target" ];
      Service.ExecStart = "${pkgs.swayest-workstyle}/bin/sworkstyle -d";
    };

    services.autotiling = {
      Unit = {
        Requires = [ "sway-session.target" ];
        After = [ "sway-session.target" ];
      };
      Install.WantedBy = [ "sway-session.target" ];
      Service.ExecStart = "${pkgs.autotiling}/bin/autotiling";
    };
  };

  xdg = {
    configFile = {
      "sworkstyle/config.toml".source = ./sworkstyle_config.toml;
    };
    mimeApps = {
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
        "application/pdf" = "org.gnome.Evince.desktop";
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
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
  };
}
