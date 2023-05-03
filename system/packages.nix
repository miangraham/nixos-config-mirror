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
    hddtemp
    hwinfo
    i2c-tools
    ipmitool
    lshw
    nix-index
    nvme-cli
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
    # xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    zip
  ;
}
