{ ... }:
{
  enable = true;
  enableAutosuggestions = true;
  enableSyntaxHighlighting = true;
  defaultKeymap = "emacs";
  sessionVariables = {
    EDITOR = "emacs -nw";
  };
  shellAliases = {
    win = "sway";
    ls = "exa --color-scale --group --git";
  };
}
