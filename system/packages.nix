{ pkgs, inputs, ... }:
let
  unstable = import ../common/unstable.nix {inherit pkgs inputs;};
  emacs = import ../common/emacs.nix {pkgs = unstable;};
in
builtins.attrValues {
  inherit emacs;

  inherit (pkgs)
    bashmount
    exfat
    file
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
    sshfs-fuse
    unrar
    unzip
    watch
    wget
    xdg-desktop-portal-wlr
    zip
  ;

  inherit (unstable)
    git
  ;
}
