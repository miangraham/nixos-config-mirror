{ pkgs, ... }:
{
  enable = true;
  wrapperFeatures.gtk = true;
  systemd.enable = true;
  checkConfig = false; # https://github.com/nix-community/home-manager/issues/5311
  config = let
    modifier = "Mod4";
    terminal = "alacritty";
  in {
    inherit modifier terminal;

    left = "j";
    down = "k";
    up = "l";
    right = "semicolon";

    menu = "fuzzel --font=Inconsolata:size=20,Terminus,monospace --border-radius=3 --inner-pad=10 --background=1f1f1fef --text-color=dcdcccff --match-color=ce3eceff --selection-color=3f5f3fff --selection-text-color=ffffefff --border-color=acac9cff";

    bars = [];

    window = {
      border = 0;
      titlebar = false;
      hideEdgeBorders = "both";
    };

    gaps = {
      smartGaps = true;
      smartBorders = "off";
      inner = 20;
      outer = 0;
    };

    focus = {
      newWindow = "urgent";
      followMouse = "no";
    };

    seat = {
      # bug with this not reappearing, kill for now
      # "*" = { hide_cursor = "when-typing enable"; };
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
      "*" = { bg = "/home/ian/.background-image fill"; };
      # nene ROG: middle
      "Ancor Communications Inc ROG PG279Q G1LMQS019376" = { pos = "1920 0"; };
      # IOData mobile monitor: left
      "Unknown EX-LDC131DM 12IZ004297DZ" = { pos = "0 0"; };
      # nano
      "HEADLESS-1" = {
        mode = "1920x1200@60Hz";
        pos = "0 0";
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

    modes = {
      passthrough = {
        "${modifier}+Shift+p" = "mode default";
      };
      resize = {
        Down = "resize grow height 10 px";
        Escape = "mode default";
        Left = "resize shrink width 10 px";
        Return = "mode default";
        Right = "resize grow width 10 px";
        Up = "resize shrink height 10 px";
        h = "resize shrink width 10 px";
        j = "resize grow height 10 px";
        k = "resize shrink height 10 px";
        l = "resize grow width 10 px";
      };
    };

    keybindings = let
      mod = modifier;
      menu = "fuzzel --font=Inconsolata:size=20,Terminus,monospace --border-radius=3 --inner-pad=10 --background=1f1f1fef --text-color=dcdcccff --match-color=ce3eceff --selection-color=3f5f3fff --selection-text-color=ffffefff --border-color=acac9cff"
;
    in {
      "${mod}+Return" = "exec ${terminal}";
      "${mod}+d" = "exec \"${menu}\"";
      "${mod}+Shift+q" = "kill";
      "${mod}+Shift+c" = "reload";
      "${mod}+Shift+e" = "exec \"swaymsg exit\"";
      "${mod}+h" = "split h";
      "${mod}+v" = "split v";
      "${mod}+f" = "fullscreen toggle";
      "${mod}+r" = "mode resize";

      "${mod}+space" = "focus mode_toggle";
      "${mod}+a" = "focus parent";

      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";

      "${mod}+Shift+space" = "floating toggle";
      "${mod}+Shift+s" = "sticky toggle";

      # Side panel
      "${mod}+p" = "resize set width 20 ppt";

      "${mod}+Shift+p" = "mode passthrough";
    };

    assigns = {
      "1" = [{ app_id = "alacritty"; }];
      "2" = [{ class="Firefox"; }];
      "3" = [{ class="Emacs"; }];
      "4" = [{ class="Godot"; }];
      "5" = [{ app_id="mpv"; }];
      "9" = [{ class="Sonixd"; }];
      "10" = [{ app_id="com.obsproject.Studio"; }];
    };

    startup = pkgs.lib.mkDefault [{
      command = "swaymsg workspace number 1";
    }{
      command = "alacritty";
    }];
  };

  extraConfigEarly = ''
    exec systemctl --user import-environment
  '';

  extraConfig = builtins.readFile ./sway.conf;
}
