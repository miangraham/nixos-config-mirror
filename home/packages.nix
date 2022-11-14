{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
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
    fractal
    fuzzel
    gh
    gimp
    godot
    graphviz
    grim
    gthumb # quick image cropping
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
    mtr
    mu
    neofetch
    nethogs
    netlify-cli
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    pandoc
    picocom
    playerctl
    # protonmail-bridge Do not run until https://github.com/ProtonMail/proton-bridge/issues/220 is fixed
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
    traceroute
    ungoogled-chromium
    write_stylus
    valgrind
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
  ]; };

  obs-remote = (unstable.callPackage ./obs-remote.nix {});

  guileInfo = pkgs.guile.info;

  eww = inputs.eww.packages.${system}.eww-wayland;

  hyprpaper = inputs.hyprpaper.packages.${system}.default;
}
