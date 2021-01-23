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
    cmus
    element-desktop
    evince
    exa
    feh
    ffmpeg
    gimp
    grim
    imagemagick
    lftp
    libreoffice
    mpv
    mu
    neofetch
    niv
    nix-direnv
    pandoc
    protonmail-bridge
    qdirstat
    ranger
    rofi
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
  inherit (pkgs.texlive.combined) scheme-small;
}
