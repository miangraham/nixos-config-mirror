{ pkgs, ... }:
let
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
]
