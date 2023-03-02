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
    inframap
    ispell
    jq
    kiwix
    krita
    lftp
    libreoffice
    lm_sensors
    logrotate
    lsp-plugins
    micro
    mtr
    mu
    ncdu
    neofetch
    nethogs
    nix-direnv
    nix-prefetch-git
    nixpkgs-review
    pandoc
    picocom
    playerctl
    qdirstat
    ranger
    reaper
    shellcheck
    slurp
    sonixd
    speedtest-cli
    tap-plugins
    tdesktop
    thunderbird
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
    libnotify
    waybar
    wev
    wl-clipboard
    wl-mirror

    # video
    freetube
    pueue
    aria2

    # streaming
    twitch-tui
  ;

  # GUI bits
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.xfce) thunar;
  eww = inputs.eww.packages.${system}.eww-wayland;
  # hyprpaper = inputs.hyprpaper.packages.${system}.default;

  # dev
  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.nodePackages) node2nix;
  inherit (pkgs.guile) info;
  # terraform = (pkgs.terraform.withPlugins (p: [ p.aws ]));
  inherit (pkgs) terraform;

  # video
  yt-dlp = (import ./yt-dlp.nix { inherit pkgs inputs; });
  # invidious = inputs.invid-testing.legacyPackages.${system}.invidious;
  invidious = pkgs.invidious;
  kodi = (pkgs.kodi.withPackages (p: with p; [ pvr-iptvsimple ]));

  # streaming
  obs-studio = pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [
    obs-pipewire-audio-capture
  ]; };
  obs-remote = (pkgs.callPackage ./obs-remote.nix {});
  twitch-chat-tui = (pkgs.callPackage ./twitch-chat-tui.nix {});

  inherit (unstable) protonmail-bridge;

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
