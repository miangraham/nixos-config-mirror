{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ../../common/desktop.nix
  ];

  boot.blacklistedKernelModules = [ ];

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

  services.dbus.enable = true;

  systemd.services = {
    sway = {
      serviceConfig = {
        Type = "simple";
        User = "ian";
      };
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "user@1000.service" ];
      after = [ "user@1000.service" ];
      environment = {
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        XDG_RUNTIME_DIR = "/run/user/1000";
      };
      path = [
        pkgs.dbus
      ];
      script = ''
        set -ex
        source /etc/profile
        source /home/ian/.profile
        env
        dbus-update-activation-environment --systemd --all
        dbus-run-session /etc/profiles/per-user/ian/bin/sway
      '';
    };
  };

  home-manager.users.ian.systemd.user.services.wayvnc = {
    Unit = {
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Install.WantedBy = [ "sway-session.target" ];
    Service.ExecStart = "${pkgs.wayvnc}/bin/wayvnc 127.0.0.1";
  };

  home-manager.users.ian.services.kanshi.enable = pkgs.lib.mkForce false;

  powerManagement.cpuFreqGovernor = "schedutil";

  system.stateVersion = "23.11";
}
