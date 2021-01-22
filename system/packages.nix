{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;

  emacs = import ../common/emacs.nix {};
  startSwayScript = import ./startsway.nix {inherit pkgs;};
in
builtins.attrValues {
  inherit emacs startSwayScript;

  inherit (pkgs)
    bashmount
    bzip2
    exfat
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
    # tdesktop # telegram client breaks on X11 now?
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
  rust = ((unstable.rustChannelOf { channel = "1.49.0"; }).rust.override {
    extensions = ["rust-src"];
  });

  inherit (unstable)
    cargo-release
    pkg-config
    gcc
    glib
    capnproto
    firefox-wayland
  ;

  inherit (unstable.glib) dev;

  # inherit (unstable.gst_all_1)
  #   gstreamer
  #   gst-libav
  #   gst-plugins-base
  #   gst-plugins-good
  #   gst-plugins-bad
  #   gst-plugins-ugly
  # ;

  # haskell
  # unstable.cabal-install
  # unstable.ghcid
  # unstable.haskell.compiler.ghc883
}
