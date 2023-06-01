{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    awscli2
    bind
    bitwarden
    cachix
    calf
    carla
    diskonaut
    dmidecode
    entr
    evince
    exa
    fd
    ffmpeg
    flac
    fuzzel
    gh
    graphviz
    grim
    gthumb # quick image cropping
    iftop
    imagemagick
    inetutils
    ispell
    jq
    kiwix
    krita
    lftp
    lm_sensors
    logrotate
    lsp-plugins
    magic-wormhole
    micro
    mu
    ncdu
    neofetch
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    okular
    pandoc
    parallel
    playerctl
    protonmail-bridge
    qdirstat
    ranger
    reaper
    samba
    shellcheck
    sioyek
    slurp
    sonixd
    speedtest-cli
    tap-plugins
    tigervnc
    tldr
    tree
    trurl
    ungoogled-chromium
    usbutils
    vlc
    xdg_utils
    yt-dlp
    zeal
    zotero

    # sway
    swayidle
    swaylock
    libnotify
    waybar
    wev
    wl-clipboard
    wl-mirror

    # video
    pueue
    aria2
  ;

  # GUI bits
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.xfce) thunar;

  # dev
  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.nodePackages) node2nix;
  inherit (pkgs.guile) info;
  inherit (pkgs) terraform;

  # video
  kodi = (pkgs.kodi.withPackages (p: with p; [ pvr-iptvsimple ]));

  # streaming
  obs-studio = pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [
    obs-pipewire-audio-capture
  ]; };
  obs-remote = (pkgs.callPackage ./obs-remote.nix {});
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
