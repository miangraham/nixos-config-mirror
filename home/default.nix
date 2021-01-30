let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;

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
