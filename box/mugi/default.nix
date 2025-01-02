{ pkgs, inputs, ... }:
let
  displayId = "DSI-2";
in
{
  imports = [
    ../../system/pi5.nix
  ];

  my.desktop.enable = true;
  my.home-network-only.enable = false;
  my.nebula-node.enable = false;

  networking = {
    hostName = "mugi";
    firewall.allowedTCPPorts = [];
    networkmanager.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  boot = {
    kernelParams = [
      "video=${displayId}:720x1280@60,rotate=90"
    ];
  };

  hardware.raspberry-pi.config.all = {
    options = {
      display_auto_detect = {
        enable = true;
        value = 0;
      };
    };
    dt-overlays = {
      disable-bt = {
        enable = true;
        params = {};
      };
      vc4-kms-dsi-ili9881-7inch = {
        enable = true;
        params = {};
      };
    };
  };

  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = 1;
  };

  home-manager.users.ian.wayland.windowManager.sway.config = {
    output.${displayId}.transform = "270";
    input."type:touch".map_to_output = displayId;
    seat."*".hide_cursor = "100";
  };

  home-manager.users.ian.wayland.windowManager.sway.config.startup = [{
    command = "systemctl --user import-environment";
  }{
    command = "/home/ian/.bin/run-firefox-kiosk.sh";
  }];

  home-manager.users.ian.programs.waybar.enable = pkgs.lib.mkForce false;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "ian";
    };
  };

  programs.light.enable = true;
  home-manager.users.ian.programs.firefox = with pkgs.lib; {
    policies = {
      DisplayBookmarksToolbar = mkForce false;
      OfferToSaveLogins = mkForce true;
    };
    profiles.ian.settings = {
      "signon.rememberSignons" = mkForce true;
      "browser.toolbars.bookmarks.visibility" = mkForce "never";
    };
  };

  home-manager.users.ian.services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 3600;
      command = "${pkgs.light}/bin/light -S 5";
      resumeCommand = "${pkgs.light}/bin/light -S 100";
    }];
  };

  security.sudo.extraRules = [{
    users = ["ian"];
    commands = [{
      command = "/run/current-system/sw/bin/reboot"; options = [ "NOPASSWD" ];
    }];
  }];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  system.stateVersion = "24.11";
}
