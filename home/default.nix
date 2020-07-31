let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  unstable = import sources.nixpkgs-unstable {};
  crate2nix = import sources.crate2nix {};
in
{
  inherit (unstable)
    # tools
    # cli-visualizer
    mpv
    obs-studio
    obs-wlrobs
    youtube-dl
    zeal

    # js
    nodejs
    yarn

    # rust
    # rustup
    rustc
    cargo
    cargo-release
    rust-analyzer

    # haskell
    cabal-install
    ghcid
  ;

  inherit (unstable.haskell.compiler) ghc883;

  crate2nix = crate2nix;
}
