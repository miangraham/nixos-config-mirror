{ pkgs, ... }:
{
  enable = true;
  package = pkgs.alacritty;
  settings = {
    env = {
      # TERM = "xterm-256color";
      TERM = "alacritty";
    };
    scrolling.history = 100000;
    selection.save_to_clipboard = true;
    hints = {
      enabled = [{
        regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
        command = "firefox";
        post_processing = true;
        mouse = {
          enabled = true;
        };
      }];
    };
    window.padding = {
      x = 10;
      y = 5;
    };
    font = {
      size = 14.0;
      normal.family = "Inconsolata Nerd Font";
    };
    window.opacity = 0.75;
    colors = {
      primary = {
        background = "#000000";
        foreground = "#ffffff";
      };
      normal = {
        black =   "#00002a";
        red =     "#ff4242";
        green =   "#59f176";
        yellow =  "#f3e877";
        blue =    "#66b0ff";
        magenta = "#f10596";
        cyan =    "#00ffff";
        white =   "#f5f5ff";
      };
    };
    key_bindings = [
      { key = "Space";     mods = "Control";       chars = "\\x00";     }
    ];
  };
}
