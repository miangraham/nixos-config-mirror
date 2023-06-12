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
    ls = "exa --color-scale --group --git";
  };
}
