{ ... }:
let
  pkgs = import ../common/stable.nix {};
  unstable = import ../common/unstable.nix {};
in
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
    foot
    gimp
    graphviz
    grim
    imagemagick
    john
    lftp
    libreoffice
    mu
    neofetch
    niv
    nix-direnv
    nyxt
    pandoc
    protonmail-bridge
    qdirstat
    ranger
    speedtest-cli
    # t
    tdesktop
    terraform
    tldr
    ungoogled-chromium
    valgrind
    vlc
    vscodium
    wofi
    zeal
    zenith
    zotero

    # js
    nodejs
    yarn

    # themes
    adapta-gtk-theme
    arc-theme
    equilux-theme
    nordic
  ;

  inherit (unstable)
    freetube
    godot
    youtube-dl
    yt-dlp
  ;

  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.terraform-providers) aws;
  inherit (pkgs.xfce) thunar;

  texliveCombined = (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small koma-script collection-latexextra; });
}
