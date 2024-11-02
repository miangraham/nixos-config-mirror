{ pkgs, ... }:
{
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  defaultKeymap = "emacs";
  sessionVariables = {
    EDITOR = "emacs -nw";
    LISTPROMPT = "";
    EXA_COLORS = "xx=35";
  };
  shellAliases = {};
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
