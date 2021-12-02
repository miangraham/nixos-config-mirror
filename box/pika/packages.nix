{ pkgs, ... }:
builtins.attrValues {
  inherit (pkgs)
    emacs-nox
    git
    htop
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
