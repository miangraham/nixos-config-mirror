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
    parted
    pavucontrol
    pciutils
    psmisc
    pulseaudio
    ripgrep
    rsync
    sshfs-fuse
    tree
    unrar
    unzip
    vim
    watch
    wget
    xdg-desktop-portal-wlr
    zip
  ;

  inherit (unstable)
    git
  ;
}
