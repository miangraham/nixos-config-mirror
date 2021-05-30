let
  pkgs = import ../common/stable.nix {};
  unstable = import ../common/unstable.nix {};

  home-packages = import ./packages.nix {};

  alacritty = import ./alacritty.nix {};
  bash = import ./bash.nix {};
  direnv = import ./direnv.nix {};
  git = import ./git.nix {};
  mpv = import ./mpv.nix {};
  secrets = import ./secrets.nix {};
  starship = import ./starship.nix {};
  tmux = import ./tmux.nix {};
in
{
  home.packages = home-packages;

  programs = {
    inherit alacritty bash direnv git mpv starship tmux;
    inherit (secrets.programs) gpg password-store;

    feh.enable = true;

    firefox = {
      enable = true;
      package = unstable.firefox-wayland;
    };

    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-wlrobs ];
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

    kanshi = {
      enable = true;
      package = pkgs.kanshi;
      extraConfig = ''
output "Ancor Communications Inc ROG PG279Q G1LMQS019376" mode 2560x1440 position 0,0
      '';
    };

    lorri.enable = true;
  };
}
