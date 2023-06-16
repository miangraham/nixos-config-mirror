{ ... }:
{
  enable = true;
  sessionVariables = {
    EDITOR = "emacs -nw";
  };
  profileExtra = ''
    source ~/.profile.private
  '';
}
