{ pkgs, config, inputs, ... }:
{
  my.fonts.enable = true;

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
    enable = true;
    type = "fcitx5";
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

  hardware.graphics.enable = true;
  security.rtkit.enable = true;

  services = {
    kanata = {
      enable = true;
      keyboards.default = {
        devices = [];
        config = ''
          (defsrc caps)
          (deflayer base lctl)
        '';
      };
    };

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
