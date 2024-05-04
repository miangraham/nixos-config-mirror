{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./network.nix
    ../../common/desktop.nix
  ];

  boot.blacklistedKernelModules = [ ];

  powerManagement = {
    cpuFreqGovernor = "schedutil";
    # powertop.enable = true;
  };

  # hardware.deviceTree = {
  #   name = "rockchip/rk3588s-nanopi-r6c.dtb";
  #   overlays = [];
  # };

  environment.systemPackages = [
    pkgs.dbus
  ];

  environment.variables = {
    WLR_BACKENDS = "headless";
    WLR_LIBINPUT_NO_DEVICES = "1";
    WAYLAND_DISPLAY = "wayland-1";
  };

  services.dbus.enable = true;

  systemd.services.sway = {
    serviceConfig = {
      Type = "simple";
      # Type = "dbus";
      User = "ian";
      # BusName = "com.miangraham.sway";
    };
    wantedBy = [ "multi-user.target" ];
    bindsTo = [ "user@1000.service" ];
    after = [ "user@1000.service" ];
    # wants = [ "user-runtime-dir@1000.service" ];
    # after = [ "user-runtime-dir@1000.service" ];
    # wants = [ "dbus.service" "dbus.socket" ];
    # after = [ "dbus.service" "dbus.socket" ];
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
      ls -lh /run/user
      ls -lh /run/user/1000

      # echo "launch go"
      # export $(dbus-launch)
      # ls -lh /run/user/1000
      env
      dbus-update-activation-environment --systemd --all
      dbus-run-session /etc/profiles/per-user/ian/bin/sway
    '';
  };

  # systemd.services.wayvnc = {

  # };
      #   systemd.user.services.waybar = {
      #   Unit = {
      #     Description =
      #       "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      #     Documentation = "https://github.com/Alexays/Waybar/wiki";
      #     PartOf = [ "graphical-session.target" ];
      #     After = [ "graphical-session-pre.target" ];
      #   };

      #   Service = {
      #     ExecStart = "${cfg.package}/bin/waybar";
      #     ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      #     Restart = "on-failure";
      #     KillMode = "mixed";
      #   };

      #   Install = { WantedBy = [ cfg.systemd.target ]; };
      # };

  home-manager.users.ian.services.kanshi.enable = pkgs.lib.mkForce false;

  system.stateVersion = "23.11";
}
