{ config, pkgs, lib, ... }:
let
  emacsMine = import ../common/emacs.nix {pkgs=pkgs;};
in
{
  imports = [
    ../common/overlays.nix
    # ./bash.nix
    ./fonts.nix
  ];

  environment.darwinConfig = "$HOME/.nix/configuration.nix";

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.bash.enable = true;

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
    watch
    wget
    youtube-dl
    zip

    # editors
    vscode

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
  ];
}
