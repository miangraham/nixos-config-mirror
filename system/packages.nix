{ pkgs, ... }:
let
  emacs = import ../common/emacs.nix {inherit pkgs;};
  startSwayScript = import ./startsway.nix {inherit pkgs;};
in
builtins.attrValues {
  inherit emacs startSwayScript;

  inherit (pkgs)
    bashmount
    bzip2
    exfat
    file
    ffmpeg
    gawk
    git
    gzip
    home-manager
    htop
    hwinfo
    lshw
    micro
    nix-index
    pamixer
    parted
    pavucontrol
    pciutils
    psmisc
    ripgrep
    rsync
    silver-searcher
    sqlite
    sshfs-fuse
    tarssh
    tree
    udiskie
    unrar
    unzip
    vim
    watch
    wget
    xdg-desktop-portal-wlr
    xdg_utils
    zip
  ;
}
