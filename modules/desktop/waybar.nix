{ lib, pkgs, ... }:
let
  failed-units-bin = pkgs.writeShellScriptBin "failed-units" ''
num_failed=$(systemctl --failed --no-legend | ${pkgs.coreutils}/bin/wc -l)

if [ $num_failed -gt 0 ]
then
  echo $num_failed
fi
  '';
in
{
  enable = true;
  systemd.enable = true;
  style = builtins.readFile ./waybarStyle.css;
  settings = { main = {
    output = [
      "eDP-1"
      "HDMI-A-2"
      "HEADLESS-1"
      "Ancor Communications Inc ROG PG279Q G1LMQS019376"
      "Dell Inc. Dell AW3423DW #tBszGDAYEB0K"
    ];
    layer = "top";
    position = "left";
    mode = "dock";
    modules-left = [
      "sway/workspaces"
    ];
    modules-center = [];
    modules-right = [
      # "custom/failed-units"
      "cpu"
      "memory"
      "disk"
      "network"
      "idle_inhibitor"
      "pulseaudio"
      "battery"
      "clock"
    ];
    "sway/workspaces" = {
      "disable-scroll" = true;
      "format" = "{name}";
    };

    "clock" = {
      "format" = "λ";
      # "format" = "";
      "format-alt" = "{:%H:%M}";
      "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
    };

    "idle_inhibitor" = {
      "format" = "{icon}";
      "format-icons" = {
        "activated" = "";
        "default" = "";
      };
      "tooltip" = false;
    };

    "pulseaudio" = {
      "format" = "{icon}";
      "format-bluetooth" = "{icon} ";
      "format-muted" = "";
      "format-icons" = {
        "headphones" = "";
        "default" = [
          ""
          ""
        ];
      };
      # hides if name, how to get back?
      "tooltip-format" = "{desc} | {volume}%";
      "scroll-step" = 5;
      "on-click" = "${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
      "on-click-right" = "${pkgs.pavucontrol}/bin/pavucontrol";
    };

    "network" = {
      "format" = "{icon}";
      "format-icons" = {
        "wifi" = [""];
        "ethernet" = [""];
        "disconnected" = [""];
      };
      "tooltip-format" = "{ipaddr}";
      "tooltip-format-wifi" = "{essid} | {signalStrength}% | {ipaddr}";
    };
    "cpu" = {
      "interval" = 5;
      "format" = "";
      "format-alt" = " {usage:2}%";
      "states" = {
        "low" = 0;
        "mid" = 25;
        "high" = 75;
        "crit" = 90;
      };
    };
    "memory" = {
      "interval" = 5;
      "format" = "";
      "format-alt" = " {}%";
      "states" = {
        "low" = 0;
        "mid" = 50;
        "high" = 75;
        "crit" = 90;
      };
    };
    "battery" = {
      "full-at" = 99;
      "states" = {
        "good" = 95;
        "warning" = 50;
        "critical" = 15;
      };
      "format" = "{icon}";
      "format-alt-charging" = "{icon}  {capacity}% ({time})";
      "format-alt-discharging" = "{icon}  {capacity}% ({time})";
      "format-icons" = [
        ""
        ""
        ""
        ""
        ""
      ];
      "tooltip-format" = "{capacity}%";
      "tooltip-format-charging" = " {capacity}% ({time})";
      "tooltip-format-discharging" = " {capacity}% ({time})";
      "tooltip-format-full" = "{capacity}%";
    };
    "disk" = {
      "format" = "";
      "format-alt" = " {percentage_used}%";
      "states" = {
        "low" = 0;
        "mid" = 50;
        "high" = 75;
        "crit" = 90;
      };
    };
    "custom/failed-units" = {
      "format" = "{}";
      "interval" = 60;
      "exec" = "${failed-units-bin}/bin/failed-units";
    };
  };};
}
