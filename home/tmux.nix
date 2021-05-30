{ ... }:
let
  pkgs = import ../common/stable.nix {};
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
        set -g @continuum-save-interval '60' # minutes
      '';
    }
  ];
}
