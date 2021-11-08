{ pkgs, ... }:
{
  enable = true;
  package = pkgs.alacritty;
  settings = {
    env = {
      TERM = "xterm-256color";
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
      use_thin_strokes = false;
      normal.family = "Inconsolata";
    };
    background_opacity = 0.75;
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
      { key = "A";         mods = "Command";       chars = "\x1ba";    }
      { key = "B";         mods = "Command";       chars = "\x1bb";    }
      { key = "C";         mods = "Command";       chars = "\x1bc";    }
      { key = "D";         mods = "Command";       chars = "\x1bd";    }
      { key = "E";         mods = "Command";       chars = "\x1be";    }
      { key = "F";         mods = "Command";       chars = "\x1bf";    }
      { key = "G";         mods = "Command";       chars = "\x1bg";    }
      { key = "H";         mods = "Command";       chars = "\x1bh";    }
      { key = "I";         mods = "Command";       chars = "\x1bi";    }
      { key = "J";         mods = "Command";       chars = "\x1bj";    }
      { key = "K";         mods = "Command";       chars = "\x1bk";    }
      { key = "L";         mods = "Command";       chars = "\x1bl";    }
      { key = "M";         mods = "Command";       chars = "\x1bm";    }
      { key = "N";         mods = "Command";       chars = "\x1bn";    }
      { key = "O";         mods = "Command";       chars = "\x1bo";    }
      { key = "P";         mods = "Command";       chars = "\x1bp";    }
      { key = "Q";         mods = "Command";       chars = "\x1bq";    }
      { key = "R";         mods = "Command";       chars = "\x1br";    }
      { key = "S";         mods = "Command";       chars = "\x1bs";    }
      { key = "T";         mods = "Command";       chars = "\x1bt";    }
      { key = "U";         mods = "Command";       chars = "\x1bu";    }
      { key = "V";         mods = "Command";       chars = "\x1bv";    }
      { key = "W";         mods = "Command";       chars = "\x1bw";    }
      { key = "X";         mods = "Command";       chars = "\x1bx";    }
      { key = "Y";         mods = "Command";       chars = "\x1by";    }
      { key = "Z";         mods = "Command";       chars = "\x1bz";    }
      { key = "A";         mods = "Command|Shift"; chars = "\x1bA";    }
      { key = "B";         mods = "Command|Shift"; chars = "\x1bB";    }
      { key = "C";         mods = "Command|Shift"; chars = "\x1bC";    }
      { key = "D";         mods = "Command|Shift"; chars = "\x1bD";    }
      { key = "E";         mods = "Command|Shift"; chars = "\x1bE";    }
      { key = "F";         mods = "Command|Shift"; chars = "\x1bF";    }
      { key = "G";         mods = "Command|Shift"; chars = "\x1bG";    }
      { key = "H";         mods = "Command|Shift"; chars = "\x1bH";    }
      { key = "I";         mods = "Command|Shift"; chars = "\x1bI";    }
      { key = "J";         mods = "Command|Shift"; chars = "\x1bJ";    }
      { key = "K";         mods = "Command|Shift"; chars = "\x1bK";    }
      { key = "L";         mods = "Command|Shift"; chars = "\x1bL";    }
      { key = "M";         mods = "Command|Shift"; chars = "\x1bM";    }
      { key = "N";         mods = "Command|Shift"; chars = "\x1bN";    }
      { key = "O";         mods = "Command|Shift"; chars = "\x1bO";    }
      { key = "P";         mods = "Command|Shift"; chars = "\x1bP";    }
      { key = "Q";         mods = "Command|Shift"; chars = "\x1bQ";    }
      { key = "R";         mods = "Command|Shift"; chars = "\x1bR";    }
      { key = "S";         mods = "Command|Shift"; chars = "\x1bS";    }
      { key = "T";         mods = "Command|Shift"; chars = "\x1bT";    }
      { key = "U";         mods = "Command|Shift"; chars = "\x1bU";    }
      { key = "V";         mods = "Command|Shift"; chars = "\x1bV";    }
      { key = "W";         mods = "Command|Shift"; chars = "\x1bW";    }
      { key = "X";         mods = "Command|Shift"; chars = "\x1bX";    }
      { key = "Y";         mods = "Command|Shift"; chars = "\x1bY";    }
      { key = "Z";         mods = "Command|Shift"; chars = "\x1bZ";    }
      { key = "Key1";      mods = "Command";       chars = "\x1b1";    }
      { key = "Key2";      mods = "Command";       chars = "\x1b2";    }
      { key = "Key3";      mods = "Command";       chars = "\x1b3";    }
      { key = "Key4";      mods = "Command";       chars = "\x1b4";    }
      { key = "Key5";      mods = "Command";       chars = "\x1b5";    }
      { key = "Key6";      mods = "Command";       chars = "\x1b6";    }
      { key = "Key7";      mods = "Command";       chars = "\x1b7";    }
      { key = "Key8";      mods = "Command";       chars = "\x1b8";    }
      { key = "Key9";      mods = "Command";       chars = "\x1b9";    }
      { key = "Key0";      mods = "Command";       chars = "\x1b0";    }
      { key = "Space";     mods = "Control";       chars = "\x00";     }
      { key = "Grave";     mods = "Command";       chars = "\x1b`";    }
      { key = "Grave";     mods = "Command|Shift"; chars = "\x1b~";    }
      { key = "Period";    mods = "Command";       chars = "\x1b.";    }
      { key = "Key8";      mods = "Command|Shift"; chars = "\x1b*";    }
      { key = "Key3";      mods = "Command|Shift"; chars = "\x1b#";    }
      { key = "Period";    mods = "Command|Shift"; chars = "\x1b>";    }
      { key = "Comma";     mods = "Command|Shift"; chars = "\x1b<";    }
      { key = "Minus";     mods = "Command|Shift"; chars = "\x1b_";    }
      { key = "Key5";      mods = "Command|Shift"; chars = "\x1b%";    }
      { key = "Key6";      mods = "Command|Shift"; chars = "\x1b^";    }
      { key = "Backslash"; mods = "Command";       chars = "\x1b\\\\"; }
      { key = "Backslash"; mods = "Command|Shift"; chars = "\x1b|";    }
    ];
  };
}
