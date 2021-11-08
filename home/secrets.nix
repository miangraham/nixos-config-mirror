{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };

  services.gpg-agent = {
    enable = true;
  };
}
