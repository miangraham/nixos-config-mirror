{ pkgs, config, ... }:
let
  lib = pkgs.lib;
  if-desktop = pkgs.lib.mkIf config.wayland.windowManager.sway.enable;

  alacritty = import ./alacritty.nix { inherit pkgs; };
  firefox = import ./firefox.nix { inherit pkgs; };
  kitty = import ./kitty.nix { inherit pkgs; };
  mpv = import ./mpv.nix { inherit pkgs; };
  waybar = import ./waybar.nix { inherit lib pkgs; };
in
{
  wayland.windowManager.sway = if-desktop (import ./sway.nix { inherit pkgs; });

  gtk = if-desktop (let
    t = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Dark-BL";
      # package = pkgs.graphite-gtk-theme;
      # name = "Graphite-Dark";
    };
    ex = { gtk-application-prefer-dark-theme = true; };
  in {
    enable = true;
    theme = t;
    iconTheme = t;
    gtk3.extraConfig = ex;
    gtk4.extraConfig = ex;
  });

  home.pointerCursor = if-desktop {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
    gtk.enable = true;
  };

  home.packages = if-desktop (builtins.attrValues {
    inherit (pkgs)
      # bitwarden # electron
      calf
      carla
      evince
      fuzzel
      grim
      gthumb # quick image cropping
      kiwix
      krita
      lsp-plugins
      okular
      playerctl
      qdirstat
      reaper
      sioyek
      slurp
      sonixd
      tap-plugins
      ungoogled-chromium
      vlc
      zeal
      # zotero # security bleh

      # sway
      swayidle
      swaylock
      libnotify
      waybar
      wev
      wl-clipboard
      wl-mirror

      # hypr
      hyprpaper
    ;

    # GUI bits
    inherit (pkgs.gnome3) adwaita-icon-theme;
    inherit (pkgs.xfce) thunar;

    # video
    kodi = (pkgs.kodi.withPackages (p: with p; [ pvr-iptvsimple ]));

    # streaming
    obs-studio = pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ]; };

    retroarch = pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
        snes9x
      ];
    };

    # authoring
    texliveCombined = (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        beamer
        collection-latexextra
        koma-script
        scheme-small

        noto
        mweights
        cm-super
        cmbright
        fontaxes
        beamertheme-metropolis
        collection-langjapanese
        collection-langchinese
      ;
    });
  });

  programs = if-desktop {
    inherit alacritty firefox kitty mpv waybar;

    feh.enable = true;

    bash.shellAliases.win = "sway";
    zsh.shellAliases.win = "sway";

    swaylock.settings = {
      color = "3f3f3f";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };

  services = if-desktop {
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

  systemd.user = if-desktop {
    targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    services.fcitx-daemon = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "/run/current-system/sw/bin/fcitx5 -D";
    };

    services.sworkstyle = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.swayest-workstyle}/bin/sworkstyle -d";
    };

    services.autotiling = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.autotiling}/bin/autotiling";
    };
  };

  xdg.configFile = if-desktop {
    "sworkstyle/config.toml".source = ./sworkstyle_config.toml;
  };
}
