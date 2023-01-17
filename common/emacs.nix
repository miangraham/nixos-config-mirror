{ pkgs, ... }:
pkgs.emacsWithPackagesFromUsePackage {
  config = "";
  package = pkgs.emacsPgtk;
  alwaysEnsure = true;
  override = epkgs: epkgs // {
    telega = epkgs.melpaPackages.telega;
  };
  extraEmacsPackages = epkgs: with epkgs; [
    ace-window
    adaptive-wrap
    aggressive-indent
    anzu
    burly
    citar
    citar-org-roam
    cmake-mode
    consult
    consult-project-extra
    corfu
    crystal-mode
    delight
    diff-hl
    direnv
    doom-themes
    drag-stuff
    editorconfig
    elfeed
    elfeed-org
    elfeed-tube
    emacsql
    emacsql-sqlite3
    ement
    eslint-fix
    fancy-compilation
    forge
    flycheck
    flycheck-rust
    fullframe
    geiser-guile
    git-link
    git-timemachine
    haskell-mode
    helpful
    hide-mode-line
    highlight-indent-guides
    htmlize
    js2-mode
    json-mode
    keycast
    ledger-mode
    magit
    marginalia
    markdown-mode
    mastodon
    nix-mode
    no-littering
    orderless
    org
    org-attach-screenshot
    org-modern
    org-ref
    org-roam
    pdf-tools
    popper
    ppp
    rainbow-delimiters
    reformatter
    ripgrep
    ron-mode
    rust-mode
    shackle
    smartparens
    telega
    templatel
    tide
    tldr
    toml-mode
    treemacs
    treemacs-magit
    vertico
    visual-fill-column
    vterm
    web-mode
    weblorg
    webpaste
    which-key
    with-editor
    writeroom-mode
    ws-butler
    yaml-mode
    yasnippet
    zoom

    # theme testing
    darktooth-theme
    jazz-theme
    mood-one-theme
    underwater-theme
  ];
}
