{ pkgs, ... }:
{
  enable = true;
  scripts = [ pkgs.mpvScripts.thumbnail ];
  config = {
    hw-dec = "auto-safe";

    # thumbnail script replaces default osc
    osc = "no";

    # close after playback
    idle = "no";

    save-position-on-quit = "yes";

    volume = 90;
    volume-max = 100;

    screenshot-directory = "~/screenshots";
    screenshot-format = "png";
    screenshot-png-compression = 8;

    audio-pitch-correction = "no";

    alang  = "jpn,jp,eng,en";
    slang  = "eng,en,enUS";
  };
  bindings = {
    WHEEL_UP = "ignore";
    WHEEL_DOWN = "ignore";
    MOUSE_BTN3 = "ignore";
    MOUSE_BTN4 = "ignore";
    AXIS_UP = "ignore";
    AXIS_DOWN = "ignore";
    AXIS_LEFT = "ignore";
    AXIS_RIGHT = "ignore";
  };
}
