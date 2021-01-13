{ ... }:
let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
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
