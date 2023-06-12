{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    awscli2
    bind
    cachix
    diskonaut
    dmidecode
    entr
    exa
    fd
    ffmpeg
    flac
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
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    pandoc
    parallel
    protonmail-bridge
    ranger
    samba
    shellcheck
    speedtest-cli
    tigervnc
    tldr
    tree
    trurl
    usbutils
    xdg_utils

    # video
    aria2
    pueue
    yt-dlp
  ;

  # dev
  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.nodePackages) node2nix;
  inherit (pkgs.guile) info;
  inherit (pkgs) terraform;

  # obs-remote = (pkgs.callPackage ./obs-remote.nix {});
  # twitch-chat-tui = (pkgs.callPackage ./twitch-chat-tui.nix {});

  inherit (unstable)
    invidious # precaching build for reuse on tiny server
  ;

  # authoring
  texliveCombined = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      beamer
      collection-latexextra
      koma-script
      scheme-small

      noto
      mweights
      cm-super
      cmbright
      fontaxes
      beamertheme-metropolis
      collection-langjapanese
      collection-langchinese
    ;
  });
}
