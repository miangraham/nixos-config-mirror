{ ... }:
{
  enable = true;
  sessionVariables = {
    EDITOR = "emacs -nw";
  };
  profileExtra = ''
    source ~/.profile.private
  '';
  shellAliases = {
    win = "sway";
    ls = "exa --color-scale --group --git";
  };
}
