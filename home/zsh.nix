{ ... }:
{
  enable = true;
  enableAutosuggestions = true;
  enableSyntaxHighlighting = true;
  defaultKeymap = "emacs";
  sessionVariables = {
    EDITOR = "emacs -nw";
    LISTPROMPT = "";
  };
  shellAliases = {
    win = "sway";
    ls = "exa --color-scale --group --git";
  };
  initExtraBeforeCompInit = ''
    zmodload zsh/complist
  '';
  initExtra = ''
    # not sure if want
    # zstyle ':completion:*' menu yes select
  '';
}
