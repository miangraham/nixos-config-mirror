{ pkgs, inputs, unstable, ... }:
builtins.attrValues {
  inherit (pkgs)
    alacritty
    aseprite
    asunder
    audacity
    awscli
    bitwarden
    cachix
    calf
    carla
    chatterino2
    cmus
    diskonaut
    du-dust
    # broke pipewire?
    # easyeffects
    element-desktop
    entr
    evince
    exa
    fd
    ffmpeg
    flac
    fontforge-gtk
    fuzzel
    gimp
    godot
    graphviz
    grim
    helvum
    iftop
    imagemagick
    ispell
    jamesdsp
    john
    jq
    kiwix
    krita
    lftp
    logrotate
    lsp-plugins
    lyrebird
    micro
    mu
    neofetch
    nethogs
    netlify-cli
    nix-direnv
    nix-prefetch-git
    pandoc
    picocom
    playerctl
    protonmail-bridge
    qdirstat
    qpwgraph
    ranger
    reaper
    shellcheck
    slurp
    sonixd
    speedtest-cli
    sublime-music
    tap-plugins
    tdesktop
    tldr
    ungoogled-chromium
    write_stylus
    valgrind
    via
    vlc
    zeal
    zenith
    zotero

    # themes
    # adapta-gtk-theme
    # arc-theme
    # equilux-theme
    # nordic

    # sway
    swayidle
    swaylock
    waybar
    libnotify
  ;

  inherit (unstable)
    freetube
    pueue
    aria2

    # sway
    sov
    wev

    twitch-tui
  ;

  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.xfce) thunar;

  # texliveCombined = (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small koma-script collection-latexextra; });

  yt-dlp = (import ./yt-dlp.nix { inherit pkgs inputs; });

  otf2bdf = pkgs.callPackage (import "${inputs.otf2bdf}/packages/otf2bdf") {};

  node2nix = pkgs.nodePackages.node2nix;

  twitch-chat-tui = (pkgs.callPackage ./twitch-chat-tui.nix {});

  obs-studio = unstable.wrapOBS { plugins = with unstable.obs-studio-plugins; [
    obs-pipewire-audio-capture
    obs-websocket
  ]; };

  obs-remote = (unstable.callPackage ./obs-remote.nix {});
}
