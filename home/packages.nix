{ pkgs, inputs, unstable, ... }:
builtins.attrValues {
  inherit (pkgs)
    alacritty
    aseprite
    audacity
    awscli
    bitwarden
    cachix
    chatterino2
    cmus
    diskonaut
    du-dust
    element-desktop
    entr
    evince
    exa
    fd
    ffmpeg
    fontforge-gtk
    fuzzel
    gimp
    godot
    graphviz
    grim
    imagemagick
    ispell
    john
    jq
    kiwix
    krita
    lftp
    micro
    mu
    neofetch
    netlify-cli
    nix-direnv
    nix-prefetch-git
    pandoc
    picocom
    protonmail-bridge
    qdirstat
    ranger
    reaper
    shellcheck
    sonixd
    speedtest-cli
    sublime-music
    tdesktop
    tldr
    ungoogled-chromium
    write_stylus
    valgrind
    vlc
    zeal
    zenith
    zotero

    # themes
    adapta-gtk-theme
    arc-theme
    equilux-theme
    nordic

    # sway
    swayidle
    swaylock
    waybar
  ;

  inherit (unstable)
    freetube
    pueue
    aria2

    # sway
    sov
    wev
  ;

  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.xfce) thunar;

  # texliveCombined = (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small koma-script collection-latexextra; });

  yt-dlp = (import ./yt-dlp.nix { inherit pkgs inputs; });

  otf2bdf = pkgs.callPackage (import "${inputs.otf2bdf}/packages/otf2bdf") {};

  node2nix = pkgs.nodePackages.node2nix;

  twitch-tui = (unstable.callPackage ./twitch-tui {});

  obs-studio = unstable.wrapOBS { plugins = [ unstable.obs-studio-plugins.obs-websocket ]; };
}
