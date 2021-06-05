{ ... }:
let
  pkgs = import ../common/stable.nix {};
  unstable = import ../common/unstable.nix {};

  emacs = import ../common/emacs.nix {};
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
    graphviz
    gzip
    home-manager
    htop
    hwinfo
    killall
    lshw
    nix-index
    pamixer
    parted
    pavucontrol
    pciutils
    pstree
    pulseeffects
    ripgrep
    rsync
    silver-searcher
    sqlite
    sshfs-fuse
    tdesktop
    tree
    udiskie
    unrar
    unzip
    vim
    watch
    wget
    xdg_utils
    zip
  ;

  # rust
  # rust = ((unstable.rustChannelOf { channel = "1.49.0"; }).rust.override {
  #   extensions = ["rust-src"];
  # });

  # inherit (unstable)
  #   rustc
  #   cargo
  #   clippy
  #   rustfmt
  #   # rust-analyzer
  #   # rustcSrc
  #   # rustLibSrc

  #   cargo-release
  #   pkg-config
  #   gcc
  #   glib
  #   capnproto
  # ;

  # inherit (unstable.glib) dev;
}
