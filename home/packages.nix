{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    asunder
    awscli2
    bitwarden
    cachix
    calf
    carla
    diskonaut
    entr
    evince
    exa
    fd
    ffmpeg
    flac
    fractal
    fuzzel
    gawk
    gh
    graphviz
    grim
    gthumb # quick image cropping
    iftop
    imagemagick
    inframap
    ispell
    jq
    kiwix
    krita
    lftp
    lm_sensors
    logrotate
    lsp-plugins
    micro
    mu
    ncdu
    neofetch
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    pandoc
    playerctl
    qdirstat
    ranger
    reaper
    shellcheck
    sioyek
    slurp
    sonixd
    speedtest-cli
    tap-plugins
    tldr
    traceroute
    tree
    ungoogled-chromium
    vlc
    xdg_utils
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
  yt-dlp = (import ./yt-dlp.nix { inherit pkgs inputs; });
  kodi = (pkgs.kodi.withPackages (p: with p; [ pvr-iptvsimple ]));

  # streaming
  obs-studio = pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [
    obs-pipewire-audio-capture
  ]; };
  obs-remote = (pkgs.callPackage ./obs-remote.nix {});
  twitch-chat-tui = (pkgs.callPackage ./twitch-chat-tui.nix {});

  inherit (unstable)
    invidious # precaching build for reuse on tiny server
    protonmail-bridge
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
