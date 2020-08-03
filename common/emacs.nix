{ ... } :
let
  sources = import ../nix/sources.nix;
  emacsOverlay = import ./emacs-overlay.nix {};
  pkgs = import sources.nixpkgs-unstable { config.allowUnfree = true; config.pulseaudio = true; overlays = [ emacsOverlay ]; };
in
pkgs.emacsWithPackagesFromUsePackage {
  config = "";
  package = pkgs.emacsGit;
  extraEmacsPackages = epkgs: with epkgs; [
    ace-window
    ag
    aggressive-indent
    anzu
    biblio
    bibtex-completion
    bongo
    company
    dante
    diminish
    doom-themes
    editorconfig
    elfeed
    elfeed-org
    emacsql
    emacsql-sqlite3
    flycheck
    flycheck-rust
    fullframe
    git-link
    git-timemachine
    haskell-mode
    hcl-mode
    helm
    helpful
    ivy
    js2-mode
    json-mode
    ledger-mode
    lsp-mode
    magit
    markdown-mode
    move-dup
    nix-mode
    org
    org-randomnote
    org-ref
    org-roam
    org-tree-slide
    pdf-tools
    projectile
    psci
    purescript-mode
    rainbow-delimiters
    rust-mode
    smartparens
    solaire-mode
    spinner
    tide
    toml-mode
    treemacs
    use-package
    vterm
    web-mode
    which-key
    ws-butler
    yaml-mode
    yasnippet
  ];
}
