let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;

  home-packages = import ./packages.nix {};

  alacritty = import ./alacritty.nix {};
  bash = import ./bash.nix {};
  secrets = import ./secrets.nix {};
  starship = import ./starship.nix {};
  tmux = import ./tmux.nix {};
in
{
  home.packages = home-packages;

  programs = {
    inherit alacritty bash starship tmux;
    inherit (secrets.programs) gpg password-store;

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
  };
}
