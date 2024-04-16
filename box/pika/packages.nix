{ pkgs, ... }:
builtins.attrValues {
  inherit (pkgs)
    bashmount
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
    nix-output-monitor
    parted
    raspberrypi-eeprom
    ripgrep
    rsync
    silver-searcher
    tldr
    tree
    udiskie
    unixbench
    unzip
    usbutils
    wget
    xdg_utils
    zip
  ;
}
