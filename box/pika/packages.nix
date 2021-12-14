{ pkgs, ... }:
builtins.attrValues {
  inherit (pkgs)
    emacs-nox
    gh
    git
    htop
    i2c-tools
    libraspberrypi
    nano
    neofetch
    ripgrep
    rsync
    silver-searcher
    udiskie
    unzip
    wget
    xdg_utils
    zip
  ;
}
