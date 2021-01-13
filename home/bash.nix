{ ... }:
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
in
{
  enable = true;
  sessionVariables = {
    EDITOR = "emacs -nw";
  };
  profileExtra = ''
    source ~/.profile.private
  '';
  shellAliases = {
    ls = "exa --color-scale --group --git";
  };
}
