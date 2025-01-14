{ config, pkgs, ... }:
{
  services.dbus.enable = true;
  users.users.ian.linger = true;

  home-manager.users.ian = {
    home.packages = [ pkgs.dbus ];

    systemd.user.sessionVariables = {
      WAYLAND_DISPLAY = "wayland-1";
      WLR_BACKENDS = "headless";
      WLR_LIBINPUT_NO_DEVICES = "1";
    };

    systemd.user.services = {
      sway = let
        inherit (builtins) concatStringsSep;
        package = config.programs.sway.package;
        startScript = pkgs.writeShellScript "start-sway.sh" ''
          set -ex
          dbus-update-activation-environment --systemd --all
          dbus-run-session ${package}/bin/sway
        '';
      in {
        Service = {
          ExecStart = "${startScript}";
          PassEnvironment = concatStringsSep " " [
            "DBUS_SESSION_BUS_ADDRESS"
            "PATH"
            "WAYLAND_DISPLAY"
            "WLR_BACKENDS"
            "WLR_LIBINPUT_NO_DEVICES"
            "XDG_RUNTIME_DIR"
          ];
        };
        Install.WantedBy = [ "default.target" ];
      };

      wayvnc = {
        Service.ExecStart = "${pkgs.wayvnc}/bin/wayvnc 127.0.0.1";
        Install.WantedBy = [ "sway-session.target" ];
        Unit = {
          Requires = [ "sway-session.target" ];
          After = [ "sway-session.target" ];
        };
      };
    };
  };
}
