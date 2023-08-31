{ pkgs, ... }:
builtins.attrValues {
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
