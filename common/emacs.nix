{ ... } :
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs-unstable conf;
in
pkgs.emacsWithPackagesFromUsePackage {
  config = "";
  package = pkgs.emacsGit;
  alwaysEnsure = true;
  extraEmacsPackages = epkgs: with epkgs; [
    ace-window
    ag
    aggressive-indent
    anzu
    beacon
    biblio
    bibtex-completion
    bongo
    company
    # consult
    dante
    diminish
    direnv
    doom-themes
    editorconfig
    elfeed
    elfeed-org
    emacsql
    emacsql-sqlite3
    # embark
    eslint-fix
    forge
    flycheck
    flycheck-rust
    fullframe
    git-link
    git-timemachine
    golden-ratio
    haskell-mode
    hcl-mode
    helm
    helpful
    ivy
    ivy-bibtex
    js2-mode
    json-mode
    ledger-mode
    lsp-mode
    lsp-ui
    magit
    # marginalia
    markdown-mode
    move-dup
    nix-mode
    no-littering
    org
    org-randomnote
    org-ref
    org-roam
    org-roam-bibtex
    org-superstar
    org-tree-slide
    pdf-tools
    projectile
    psci
    purescript-mode
    rainbow-delimiters
    ripgrep
    rust-mode
    selectrum
    selectrum-prescient
    smartparens
    solaire-mode
    spinner
    tide
    toml-mode
    treemacs
    treemacs-magit
    treemacs-projectile
    # unicode-fonts
    use-package
    vterm
    web-mode
    which-key
    ws-butler
    yaml-mode
    yasnippet
  ];
}
