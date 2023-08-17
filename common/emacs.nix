{ pkgs, ... }:
pkgs.emacsWithPackagesFromUsePackage {
  config = "";
  package = pkgs.emacs-unstable-pgtk;
  alwaysEnsure = true;
  override = epkgs: epkgs // {
    telega = epkgs.melpaPackages.telega;
  };
  extraEmacsPackages = epkgs: with epkgs; [
    ace-window
    adaptive-wrap
    aggressive-indent
    anzu
    biome
    burly
    catppuccin-theme
    citar
    citar-org-roam
    cmake-mode
    consult
    consult-project-extra
    corfu
    crystal-mode
    delight
    denote
    diff-hl
    direnv
    doom-themes
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
    lua-mode
    magit
    marginalia
    markdown-mode
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
    tempel
    templatel
    terraform-mode
    tide
    tldr
    toml-mode
    typescript-mode
    vertico
    visual-fill-column
    vterm
    web-mode
    weblorg
    webpaste
    which-key
    whitespace-cleanup-mode
    writeroom-mode
    ws-butler
    yaml-mode
    zoom

    pkgs.mu

    # theme testing
    # darktooth-theme
    # jazz-theme
    # underwater-theme
    color-theme-modern
  ];
}
