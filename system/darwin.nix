{ config, pkgs, lib, ... }:
let
  emacsMine = import ../common/emacs.nix {inherit pkgs;};
  overlays = import ../common/overlays.nix {};
in
{
  imports = [
    ./fonts.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = overlays;
  };

  programs.bash.enable = true;

  environment.darwinConfig = "$HOME/.nix/configuration.nix";

  environment.systemPackages = with pkgs; [
    # base
    nix
    niv
    cacert

    # sdks/libs
    dotnet-sdk
    fontconfig
    harfbuzz
    openjdk11
    openssl

    # tools
    alacritty
    awscli
    bzip2
    coreutils
    emacsMine
    exa
    expect
    ffmpeg
    findutils
    gawk
    git
    gitAndTools.git-subrepo
    gnugrep
    gnupg
    gnused
    graphviz
    gzip
    htop
    imagemagick
    killall
    lftp
    mu
    neofetch
    pandoc
    pstree
    ranger
    ripgrep
    rsync
    silver-searcher
    sqlite
    speedtest-cli
    starship
    terraform
    terraform-providers.aws
    tmux
    unrar
    unzip
    valgrind
    vim
    vscode
    watch
    wget
    youtube-dl
    zip

    # haskell
    haskell.compiler.ghc883
    cabal-install
    ghcid

    # js
    nodejs
    yarn

    # rust
    rustup
    rust-analyzer

    texlive.combined.scheme-small
  ];
}
