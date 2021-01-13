let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  unstable = import sources.nixpkgs-unstable {};
in
{
  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-wlrobs
    ];
  };
}
