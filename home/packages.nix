{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    awscli2
    bind
    cachix
    diskonaut
    dmidecode
    duf
    entr
    fd
    ffmpeg
    flac
    geekbench
    gh
    graphviz
    iftop
    imagemagick
    inetutils
    ispell
    jq
    lftp
    lm_sensors
    logrotate
    magic-wormhole
    mu
    ncdu
    neofetch
    nheko
    nix-direnv
    nix-prefetch
    nix-prefetch-git
    nixpkgs-review
    nvd
    pandoc
    parallel
    protonmail-bridge
    ranger
    samba
    shellcheck
    speedtest-cli
    tigervnc
    tldr
    tokei
    tree
    trurl
    usbutils
    xdg_utils
    zotero

    # video
    aria2
    pueue
    yt-dlp
  ;

  # dev
  inherit (pkgs.gitAndTools)
    git-open
    git-subrepo
  ;
  inherit (pkgs.nodePackages) node2nix;
  inherit (pkgs) terraform;

  inherit (unstable)
  ;
}
