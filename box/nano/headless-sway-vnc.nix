{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  environment = {
    systemPackages = [
      pkgs.dbus
    ];

    variables = {
      WLR_BACKENDS = "headless";
      WLR_LIBINPUT_NO_DEVICES = "1";
      WAYLAND_DISPLAY = "wayland-1";
    };
  };

  users.users.ian.linger = true;
  services.dbus.enable = true;
  security.polkit.enable = true;

  home-manager.users.ian = {
    home.packages = [ pkgs.dbus ];

    services.kanshi.enable = pkgs.lib.mkForce false;

    systemd.user.services = {
      sway = let
        startScript = pkgs.writeShellScript "start-sway.sh" ''
          set -ex
          dbus-update-activation-environment --systemd --all
          dbus-run-session /etc/profiles/per-user/ian/bin/sway
        '';
      in {
        Install.WantedBy = [ "default.target" ];
        Service = {
          PassEnvironment = "PATH";
          Environment = [
            "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
            "XDG_RUNTIME_DIR=/run/user/1000"
            "WLR_BACKENDS=headless"
            "WLR_LIBINPUT_NO_DEVICES=1"
            "WAYLAND_DISPLAY=wayland-1"
          ];
          ExecStart = "${startScript}";
        };
      };

      wayvnc = {
        Unit = {
          Requires = [ "sway-session.target" ];
          After = [ "sway-session.target" ];
        };
        Install.WantedBy = [ "sway-session.target" ];
        Service.ExecStart = "${pkgs.wayvnc}/bin/wayvnc 127.0.0.1";
      };
    };

  };
}
