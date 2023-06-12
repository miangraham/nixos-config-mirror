{ pkgs, ... }:
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
    ls = "exa --color-scale --group --git";
  };
  initExtraBeforeCompInit = ''
    zmodload zsh/complist
  '';
  initExtra = ''
    # not sure if want
    # zstyle ':completion:*' menu yes select
    source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
  '';
  initExtraFirst = ''
    [[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
  '';
}
