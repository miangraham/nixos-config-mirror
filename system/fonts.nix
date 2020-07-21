{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    # general use
    fantasque-sans-mono
    inconsolata
    terminus_font_ttf

    # icons
    font-awesome

    # jp
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];
}
