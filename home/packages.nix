{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    awscli2
    bind
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
    kondo
    lftp
    lm_sensors
    logrotate
    magic-wormhole
    mu
    ncdu
    neofetch
    nix-direnv
    nix-prefetch
    nix-prefetch-git
    nixpkgs-review
    nvd
    pandoc
    parallel
    protonmail-bridge
    ranger
    rclone
    samba
    shellcheck
    speedtest-cli
    tldr
    tokei
    tree
    trurl
    unixbench
    usbutils
    wayvnc
    xdg_utils

    # video
    aria2
    pueue
    yt-dlp
  ;

  # for manual generations cleanup, why auto no work
  inherit (inputs.home-manager.packages.${system}) home-manager;

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
