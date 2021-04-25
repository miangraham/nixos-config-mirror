{ ... }:
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;
in
builtins.attrValues {
  inherit (pkgs)
    alacritty
    audacity
    awscli
    bitwarden
    cmus
    element-desktop
    evince
    exa
    ffmpeg
    gimp
    grim
    hugo
    imagemagick
    john
    lftp
    libreoffice
    mu
    neofetch
    niv
    nix-direnv
    pandoc
    protonmail-bridge
    qdirstat
    ranger
    slack
    speedtest-cli
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
