{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;

  emacsMine = import ../common/emacs.nix {};
  startSwayScript = import ./startsway.nix {pkgs=pkgs;};
in
with pkgs; [
  alacritty
  audacity
  awscli
  bzip2
  cmus
  direnv
  emacsMine
  evince
  exa
  feh
  ffmpeg
  gawk
  gimp
  git
  gitAndTools.git-subrepo
  gnome3.adwaita-icon-theme
  gnupg
  graphviz
  grim
  gzip
  htop
  hwinfo
  imagemagick
  killall
  krita
  lftp
  lshw
  mu
  neofetch
  niv
  nix-index
  pamixer
  pandoc
  pavucontrol
  pciutils
  pstree
  pulseeffects
  qdirstat
  ranger
  ripgrep
  rofi
  rsync
  silver-searcher
  sqlite
  speedtest-cli
  starship
  terraform
  terraform-providers.aws
  tdesktop # telegram client
  tldr
  tmux
  unrar
  unzip
  valgrind
  vim
  vlc
  vscode
  watch
  wget
  wofi
  xdg_utils
  zip

  python38Packages.glances

  startSwayScript

  texlive.combined.scheme-small

  # tools
  # cli-visualizer
  unstable.mpv
  unstable.obs-studio
  unstable.obs-wlrobs
  unstable.youtube-dl
  unstable.zeal

  # js
  unstable.nodejs
  unstable.yarn

  # rust
  (unstable.latest.rustChannels.stable.rust.override {
    extensions = ["rust-src"];
  })
  unstable.cargo-release

  unstable.pkg-config
  unstable.gst_all_1.gstreamer
  unstable.gst_all_1.gst-libav
  unstable.gst_all_1.gst-plugins-base
  unstable.gst_all_1.gst-plugins-good
  unstable.gst_all_1.gst-plugins-bad
  unstable.gst_all_1.gst-plugins-ugly
  unstable.gcc
  unstable.glib
  unstable.glib.dev
  unstable.capnproto
  unstable.ungoogled-chromium
  unstable.firefox-wayland
  unstable.element-desktop

  # haskell
  # unstable.cabal-install
  # unstable.ghcid
  # unstable.haskell.compiler.ghc883

  unstable.godot
]
