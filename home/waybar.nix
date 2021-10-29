{ config, lib, ... }:
let
in
{
  enable = true;
  style = builtins.readFile ./waybarStyle.css;
  settings = [{
    layer = "top";
    position = "bottom";
    modules-left = [
      "sway/workspaces"
    ];
    modules-center = [];
    modules-right = [
      "idle_inhibitor"
      "pulseaudio"
      "cpu"
      "memory"
      "custom/storage"
      "network"
      "battery"
      "clock"
    ];
    modules = {
      "sway/workspaces" = {
        "disable-scroll" = true;
        "format" = "{name}";
      };

      "clock" = {
        "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
        "format-alt" = "{:%Y-%m-%d}";
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
        "format" = "{icon}  {volume}%";
        "format-bluetooth" = "{icon}  {volume}%";
        "format-muted" = "";
        "format-icons" = {
          "headphones" = "";
          "default" = [
            ""
            ""
              ];
        };
        "scroll-step" = 5;
        "on-click" = "pamixer -t";
        "on-click-right" = "pavucontrol";
      };

      "network" = {
        "format" = "{icon}";
        "format-wifi" = "{icon} {essid}";
        "format-alt" = "{icon} {ipaddr}/{cidr}";
        "format-alt-click" = "click-right";
        "format-icons" = {
          "wifi" = [""];
          "ethernet" = [""];
          "disconnected" = ["DISC"];
        };
        "on-click" = "termite -e sudo wifi-menu";
        "tooltip-format" = "{ifname}";
        "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
      };
      "cpu" = {
        "interval" = 5;
        "format" = " {usage:2}%";
      };
      "memory" = {
        "interval" = 5;
        "format" = " {}%";
      };
      "battery" = {
        "states" = {
          "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = "{icon} {capacity}%";
        "format-discharging" = "{icon} {capacity}% ({time})";
        "format-full" = "{icon} {capacity}%";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      "custom/storage" = {
        "format" = " {}";
        "format-alt" = " {percentage}%";
        "format-alt-click" = "click-right";
        "return-type" = "json";
        "interval" = 60;
        "exec" = "~/.config/waybar/storage.sh";
      };
    };
  }];
}
