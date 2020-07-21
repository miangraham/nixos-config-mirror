{ ... }:
{
  programs.bash.shellAliases = {
    ls = "exa --color-scale --git";
  };

  programs.bash.interactiveShellInit = ''
    eval "$(starship init bash)"
  '';
}
