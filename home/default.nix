{ ... }: { pkgs, config, inputs, ... }:
let
  unstable = import ../common/unstable.nix { inherit pkgs inputs; };
  home-packages = import ./packages.nix { inherit pkgs inputs unstable; };
  accounts = import ./accounts.nix { inherit pkgs; };

  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  foot = import ./foot.nix {};
  git = import ./git.nix { inherit pkgs; };
  secrets = import ./secrets.nix { inherit pkgs; };
  ssh = import ./ssh.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
  zsh = import ./zsh.nix { inherit pkgs; };
in
{
  inherit accounts;

  home = {
    packages = home-packages;
    stateVersion = "24.05";
    username = "ian";
    homeDirectory = "/home/ian";
    sessionPath = [
      "$HOME/.bin"
    ];
  };

  programs = {
    inherit bash direnv foot git ssh starship tmux zsh;
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
      extraOptions = [
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
        show_program_path = 0;
      };
    };

    nushell = {
      enable = true;
      environmentVariables = {
        EDITOR = "emacs -nw";
        LISTPROMPT = "";
        EXA_COLORS = "xx=35";
      };
      shellAliases = {};
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
}
