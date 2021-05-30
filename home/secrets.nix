{ ... }:
let
  pkgs = import ../common/stable.nix {};
in
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
