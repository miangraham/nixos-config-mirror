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

  # theme = "Hurtado";
  # theme = "Ir Black";
  # theme = "Kaolin Galaxy";
  # theme = "Tango Dark";
  theme = "Tokyo Night";
  # theme = "Tomorrow Night Bright";

  font = {
    package = pkgs.sarasa-gothic;
    name = "Sarasa Mono J";
    size = 14;
  };
  environment = {
    # LANG = "en_US.UTF-8";
    # LC_ALL = "en_US.UTF-8";
    # TERM = "xterm-256color";
  };
  # extraConfig = ''
  #   modify_font cell_width 100%
  # '';
}
