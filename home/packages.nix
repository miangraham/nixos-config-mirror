{ pkgs, unstable, ... }:
builtins.attrValues {
  inherit (pkgs)
    alacritty
    audacity
    awscli
    bitwarden
    cmus
    diskonaut
    du-dust
    element-desktop
    evince
    exa
    fd
    ffmpeg
    fontforge-gtk
    foot
    gimp
    graphviz
    grim
    imagemagick
    john
    jq
    lftp
    mu
    neofetch
    niv
    nix-direnv
    pandoc
    picocom
    qdirstat
    ranger
    speedtest-cli
    tdesktop
    terraform
    tldr
    ungoogled-chromium
    valgrind
    vlc
    vscodium
    zeal
    zenith
    zotero

    # themes
    adapta-gtk-theme
    arc-theme
    equilux-theme
    nordic
  ;

  inherit (unstable)
    freetube
    godot
    pueue
    youtube-dl
    yt-dlp
    aria2
  ;

  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.terraform-providers) aws;
  inherit (pkgs.xfce) thunar;

  texliveCombined = (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small koma-script collection-latexextra; });
}
