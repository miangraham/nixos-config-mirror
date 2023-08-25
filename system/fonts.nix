{ pkgs, ... }:
with pkgs; {
  fontDir.enable = true;
  enableDefaultFonts = true;
  # fontconfig.enable = true;
  fonts = [
    # general use
    alegreya
    anonymousPro
    cascadia-code
    fantasque-sans-mono
    fira
    fira-code
    fira-code-symbols
    fira-mono
    hack-font
    ia-writer-duospace
    ibm-plex
    inconsolata
    # intel-one-mono # unstable
    iosevka
    jetbrains-mono
    libre-caslon
    mplus-outline-fonts.githubRelease
    overpass
    oxygenfonts
    proggyfonts
    recursive
    roboto-mono
    source-code-pro
    terminus_font_ttf
    victor-mono

    # icons
    font-awesome
    emojione
    twemoji-color-font

    # jp
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    sarasa-gothic

    (pkgs.nerdfonts.override {
      fonts = [
        "Inconsolata"
        "Terminus"
      ];
    })
  ];
}
