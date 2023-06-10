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
    p7zip
    parted
    pavucontrol
    pciutils
    psmisc
    ripgrep
    smartmontools
    sshfs-fuse
    unrar
    unzip
    watch
    wget
    zip
  ;
}
