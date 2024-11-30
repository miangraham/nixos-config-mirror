# Only testing occasionally due to ugly resize on open. Switch over some day?
{ pkgs, ... }:
{
  enable = true;
  package = pkgs.kitty;
  settings = {
    background = "#000000";
    foreground = "#f0f0f0";
    cursor = "#f0f0f0";
    background_opacity = "0.75";

    cursor_blink_interval = 0;
    enable_audio_bell = false;
    scrollback_lines = 100000;
    term = "xterm-256color";
    update_check_interval = 0;
    window_padding_width = 10;
  };

  themeFile = "tokyo_night_night";

  font = {
    package = pkgs.sarasa-gothic;
    name = "Sarasa Mono J";
    size = 14;
  };
  environment = {};
}
