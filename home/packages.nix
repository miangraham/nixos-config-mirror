{ pkgs, inputs, unstable, system, ... }: let
in
builtins.attrValues {
  inherit (pkgs)
    asunder
    bitwarden
    cachix
    calf
    carla
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
    fractal
    fuzzel
    gawk
    gh
    gimp
    godot
    graphviz
    grim
    gthumb # quick image cropping
    iftop
    imagemagick
    ispell
    jq
    kiwix
    krita
    lftp
    logrotate
    lsp-plugins
    micro
    mtr
    mu
    neofetch
    nethogs
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    pandoc
    picocom
    playerctl
    # protonmail-bridge Do not run until https://github.com/ProtonMail/proton-bridge/issues/220 is fixed
    qdirstat
    ranger
    reaper
    shellcheck
    slurp
    sonixd
    speedtest-cli
    tap-plugins
    tdesktop
    tldr
    traceroute
    tree
    ungoogled-chromium
    vlc
    xdg_utils
    zeal
    zenith
    zotero

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
    wev

    twitch-tui
  ;

  # GUI bits
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.xfce) thunar;
  eww = inputs.eww.packages.${system}.eww-wayland;
  hyprpaper = inputs.hyprpaper.packages.${system}.default;

  # dev
  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.nodePackages) node2nix;
  inherit (pkgs.guile) info;

  # video
  yt-dlp = (import ./yt-dlp.nix { inherit pkgs inputs; });
  invidious = inputs.invid-testing.legacyPackages.${system}.invidious;
  kodi = (unstable.kodi.withPackages (p: with p; [ pvr-iptvsimple ]));

  # streaming
  obs-studio = unstable.wrapOBS { plugins = with unstable.obs-studio-plugins; [
    obs-pipewire-audio-capture
  ]; };
  obs-remote = (unstable.callPackage ./obs-remote.nix {});
  twitch-chat-tui = (pkgs.callPackage ./twitch-chat-tui.nix {});
}
