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
    nix-output-monitor
    nvme-cli
    p7zip
    parted
    pavucontrol
    pciutils
    powertop
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
