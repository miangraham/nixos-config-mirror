{ pkgs, ... }:
{
  enable = true;
  wrapperFeatures.gtk = true;
  systemdIntegration = true;
  config = {
    modifier = "Mod4";
    left = "j";
    down = "k";
    up = "l";
    right = "semicolon";

    terminal = "alacritty";
    menu = "fuzzel --font=Inconsolata:size=20,Terminus,monospace --border-radius=3 --inner-pad=10 --background=1f1f1fef --text-color=dcdcccff --match-color=ce3eceff --selection-color=3f5f3fff --selection-text-color=ffffefff --border-color=acac9cff";

    keybindings = {};
    bars = [];

    window = {
      border = 0;
      hideEdgeBorders = "none";
    };

    gaps = {
      smartGaps = true;
      smartBorders = "no_gaps";
      inner = 20;
      outer = 0;
    };

    focus = {
      newWindow = "urgent";
      followMouse = "yes";
    };

    input = {
      "*" = {
        xkb_layout = "us";
        xkb_options = "ctrl:nocaps";
      };
      "type:pointer" = {
        pointer_accel = "0";
        accel_profile = "flat";
      };
      "type:touchpad" = {
        natural_scroll = "enabled";
      };
      "Topre Corporation HHKB Professional" = {
        xkb_model = "hhk";
      };
      "Logitech USB Receiver Mouse" = {
        pointer_accel = "-0.99";
      };
      "1133:50495:Logitech_USB_Receiver_Mouse" = {
        pointer_accel = "-0.99";
      };
      "1390:228:ELECOM_ELECOM_BlueLED_Mouse" = {
        accel_profile = "flat";
        pointer_accel = "0";
      };
    };

    output = {
      "*" = {
        bg = "/home/ian/.background-image fill";
      };
    };

    fonts = {
      names = [ "Fantasque Sans Mono" ];
      size = 15.0;
    };

    colors = {
      background = "#3f3f3f";
      focused = {
        border = "#333333";
        background = "#000000";
        text = "#F0DFAF";
        indicator = "#ffff00";
        childBorder = "#8f8f8f";
      };
      focusedInactive = {
        border = "#1b1b1b";
        background = "#000000";
        text = "#ffffff";
        indicator = "#484e50";
        childBorder = "#1b1b1b";
      };
      unfocused = {
        border = "#0f0f0f";
        background = "#000000";
        text = "#888888";
        indicator = "#292d2e";
        childBorder = "#4f4f4f";
      };
      urgent = {
        border = "#2f343a";
        background = "#900000";
        text = "#ffffff";
        indicator = "#900000";
        childBorder = "#900000";
      };
      placeholder = {
        border = "#000000";
        background = "#0c0c0c";
        text = "#ffffff";
        indicator = "#000000";
        childBorder = "#0c0c0c";
      };
    };
  };

  extraConfig = builtins.readFile ./sway.conf;
}