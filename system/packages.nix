{ pkgs, ... }:
let
  emacsMine = import ../common/emacs.nix {pkgs=pkgs;};
  startSwayScript = import ./startsway.nix {pkgs=pkgs;};
in
{
  environment.systemPackages = with pkgs; [
    alacritty
    awscli
    bzip2
    chromium
    cmus
    emacsMine
    exa
    evince
    feh
    ffmpeg
    firefox-wayland
    gawk
    gimp
    git
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
  ];
}
