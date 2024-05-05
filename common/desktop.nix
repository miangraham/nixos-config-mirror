{ pkgs, config, ... }:
{
  boot = {
    # screen streaming modules not currently used
    # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # kernelModules = [ "v4l2loopback" ];
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 524288;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  environment = {
    systemPackages = with pkgs; [
      # xdg-desktop-portal-wlr
    ];
    variables = {
      QT_STYLE_OVERRIDE = pkgs.lib.mkForce "adwaita-dark";
    };
  };

  programs = {
    adb.enable = true;
    sway.enable = true;
    wshowkeys.enable = true;
  };

  hardware.opengl.enable = true;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home-manager.users.ian.wayland.windowManager.sway.enable = true;
}
