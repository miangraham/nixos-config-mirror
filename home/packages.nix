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
    # cmus  # depends on vulnerable ffmpeg version
    element-desktop
    evince
    exa
    ffmpeg
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
    slack
    speedtest-cli
    tdesktop
    terraform
    tldr
    ungoogled-chromium
    valgrind
    vlc
    vscode
    wofi
    zeal
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
    godot
    youtube-dl
  ;

  inherit (pkgs.gitAndTools) git-subrepo;
  inherit (pkgs.gnome3) adwaita-icon-theme;
  inherit (pkgs.terraform-providers) aws;
  inherit (pkgs.xfce) thunar;

  texliveCombined = (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small koma-script collection-latexextra; });
}
