{ config, pkgs, lib, ... }:
let
  emacsMine = import ../common/emacs.nix {pkgs=pkgs;};
in
{
  imports = [
    ../common/overlays.nix
    # ./bash.nix
    ./fonts.nix
  ];

  environment.darwinConfig = "$HOME/.nix/configuration.nix";

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.bash.enable = true;

  environment.systemPackages = with pkgs; [
    glances
    vim
  ];
}
