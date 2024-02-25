{ pkgs, ... }:
builtins.attrValues {
  inherit (pkgs)
    diskonaut
    emacs29-nox
    gh
    git
    htop
    i2c-tools
    libraspberrypi
    nano
    neofetch
    nixpkgs-review
    raspberrypi-eeprom
    ripgrep
    rsync
    silver-searcher
    tldr
    tree
    udiskie
    unzip
    usbutils
    wget
    xdg_utils
    zip
  ;
}
