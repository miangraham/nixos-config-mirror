{ ... }:
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;

  tmuxPlugins = pkgs.tmuxPlugins;
in
{
  enable = true;
  package = pkgs.tmux;
  clock24 = true;
  historyLimit = 10000;
  shortcut = "t";
  terminal = "tmux-256color";
  plugins = [
    {
      plugin = tmuxPlugins.resurrect;
    }
    {
      plugin = tmuxPlugins.continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-boot 'on'
        set -g @continuum-save-interval '60' # minutes
      '';
    }
  ];
}
