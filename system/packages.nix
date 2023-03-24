{ pkgs, ... }:
let
  emacs = import ../common/emacs.nix { inherit pkgs; };
in
builtins.attrValues {
  inherit emacs;

  inherit (pkgs)
    bashmount
    exfat
    file
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
}
