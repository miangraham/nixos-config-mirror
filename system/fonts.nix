{ pkgs, ... }:
with pkgs; [
  # general use
  fantasque-sans-mono
  inconsolata
  terminus_font_ttf

  cascadia-code
  fira-code
  jetbrains-mono
  iosevka
  hack-font
  roboto-mono
  anonymousPro
  mplus-outline-fonts
  ibm-plex
  ia-writer-duospace
  overpass
  alegreya
  source-code-pro

  oxygenfonts

  # icons
  font-awesome
  emojione
  twemoji-color-font
  # (nerdfonts.override {
  #   fonts = [
  #     "IBMPlexMono"
  #     "JetBrainsMono"
  #     "Overpass"
  #     "Cousine"
  #     "RobotoMono"
  #     "FiraCode"
  #     "SourceCodePro"
  #   ];
  # })

  # jp
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  sarasa-gothic
]
