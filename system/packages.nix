{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;
  crate2nix = import sources.crate2nix {};

  emacsMine = import ../common/emacs.nix {};
  startSwayScript = import ./startsway.nix {pkgs=pkgs;};
in
with pkgs; [
  alacritty
  audacity
  awscli
  bzip2
  chromium
  cmus
  direnv
  emacsMine
  evince
  exa
  feh
  ffmpeg
  firefox-wayland
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
  imagemagick
  killall
  krita
  lftp
  mu
  neofetch
  niv
  pamixer
  pandoc
  pavucontrol
  pstree
  pulseeffects
  qdirstat
  ranger
  ripgrep
  rofi
  rsync
  rustfmt
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
  unstable.rustc
  unstable.cargo
  unstable.cargo-release
  unstable.rust-analyzer
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

  # haskell
  unstable.cabal-install
  unstable.ghcid
  unstable.haskell.compiler.ghc883

  crate2nix
]
