{ pkgs, ... }:
builtins.attrValues {
  inherit (pkgs)
    emacs-nox
    git
    htop
    libraspberrypi
    nano
    neofetch
    ripgrep
    rsync
    silver-searcher
    unzip
    wget
    zip
  ;
}
