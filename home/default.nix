{ ... }: { pkgs, config, inputs, system, ... }:
let
  lib = pkgs.lib;
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs inputs unstable system; };
  accounts = import ./accounts.nix { inherit pkgs; };

  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  git = import ./git.nix { inherit pkgs; };
  secrets = import ./secrets.nix { inherit pkgs; };
  ssh = import ./ssh.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
  zsh = import ./zsh.nix { inherit pkgs; };
in
{
  imports = [ ./desktop.nix ];

  inherit accounts;
  home = {
    packages = home-packages;
    stateVersion = "23.11";
    username = "ian";
    homeDirectory = "/home/ian";
    sessionPath = [
      "$HOME/.bin"
    ];
  };

  programs = {
    inherit bash direnv git ssh starship tmux zsh;
    inherit (secrets.programs) gpg password-store;

    bat.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    mbsync.enable = true;
    mu.enable = true;
    zoxide.enable = true;

    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = false;
        show_help = false;
        style = "compact";
        update_check = false;
      };
    };

    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        # "--color-scale size"
        "--git"
        "--group"
      ];
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
}
