{ pkgs, inputs, ... }:
let
  unstable = import ../common/unstable.nix {inherit pkgs inputs;};
  emacs = import ../common/emacs.nix {pkgs = unstable;};
  startSwayScript = import ./startsway.nix {inherit pkgs;};
in
builtins.attrValues {
  inherit emacs startSwayScript;

  inherit (pkgs)
    bashmount
    bzip2
    exfat
    file
    gawk
    git
    gzip
    home-manager
    htop
    hwinfo
    jq
    lshw
    micro
    nix-index
    pamixer
    parted
    pavucontrol
    pciutils
    psmisc
    ripgrep
    # rss-bridge
    # rss-bridge-cli
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
