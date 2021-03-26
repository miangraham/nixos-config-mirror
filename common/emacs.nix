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
    avy
    beacon
    biblio
    bibtex-completion
    bongo
    company
    dante
    diminish
    direnv
    doom-themes
    drag-stuff
    editorconfig
    elfeed
    elfeed-org
    emacsql
    emacsql-sqlite3
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
    hydra
    ivy
    ivy-bibtex
    js2-mode
    json-mode
    ledger-mode
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    nix-mode
    no-littering
    orderless
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
    ron-mode
    rust-mode
    selectrum
    selectrum-prescient
    shackle
    smartparens
    solaire-mode
    spinner
    tide
    toml-mode
    treemacs
    treemacs-magit
    treemacs-projectile
    use-package
    vterm
    web-mode
    weblorg
    which-key
    with-editor
    ws-butler
    yaml-mode
    yasnippet
  ];
}
