{ pkgs, inputs, ... }:
let
  unstable = import ../common/unstable.nix {inherit pkgs inputs;};
  emacs = import ../common/emacs.nix {pkgs = unstable;};
in
builtins.attrValues {
  inherit emacs;

  inherit (pkgs)
    bashmount
    bzip2
    exfat
    file
    gawk
    gzip
    hwinfo
    lshw
    nix-index
    pamixer
    parted
    pavucontrol
    pciutils
    psmisc
    pulseaudio
    ripgrep
    rsync
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
