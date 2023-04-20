{ pkgs, ... }:
pkgs.emacsWithPackagesFromUsePackage {
  config = "";
  package = (pkgs.emacsUnstable.override { withPgtk = true; });
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
    drag-stuff
    eat
    editorconfig
    ef-themes
    elfeed
    elfeed-org
    elfeed-tube
    embark
    embark-consult
    eslint-fix
    fancy-compilation
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
    mood-one-theme
    moody
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
    quickrun
    rainbow-delimiters
    ron-mode
    rust-mode
    shackle
    sideline
    sideline-flymake
    smartparens
    sudo-edit
    telega
    templatel
    terraform-mode
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
    # with-editor
    whitespace-cleanup-mode
    writeroom-mode
    ws-butler
    yaml-mode
    yasnippet
    zoom

    pkgs.mu

    # theme testing
    # darktooth-theme
    # jazz-theme
    # underwater-theme
    # catppuccin-theme
  ];
}
