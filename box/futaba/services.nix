{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    syncthing.guiAddress = "0.0.0.0:8384";

    endlessh = {
      enable = true;
      openFirewall = true;
    };

    # box specific due to ACME, rip
    nginx = {
      enable = true;
      user = "nginx";
      virtualHosts = {
        futaba = {
          serverName = "192.168.0.128";
          root = "/var/www";
          default = true;
        };
        "ian.tokyo" = {
          serverName = "ian.tokyo";
          root = "/var/www";
          addSSL = true;
          enableACME = true;
        };
        invid = {
          enableACME = false;
          forceSSL = false;
        };
      };
    };

    invidious = {
      enable = true;
      package = unstable.invidious;
      domain = "invid";
      port = 9999;
      nginx.enable = true;
      database.createLocally = true;
      settings = {
        registration_enabled = true;
        login_enabled = true;
        captcha_enabled = false;
        popular_enabled = false;
        enable_user_notifications = false;
        default_user_preferences = {
          region = "JP";
          related_videos = false;
          comments = [ "" "" ];
          feed_menu = [ "Subscriptions" "none" "none" "none" ];
          default_home = "Subscriptions";
        };
      };
      extraSettingsFile = "/etc/invidious/config.yml";
    };

    freshrss = {
      enable = true;
      baseUrl = "http://freshrss";
      dataDir = "/srv/freshrss/data";
      defaultUser = "ian";
      passwordFile = "/srv/freshrss/freshrss_admin_phrase";
    };
    phpfpm.pools.freshrss.phpEnv.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";

    znc = {
      enable = true;
      openFirewall = true;
      dataDir = "/srv/znc";
      confOptions = {
        passBlock = "";
      };
      # extraFlags = [ "--debug" ];
    };
    logrotate.settings.znc = {
      files = "/srv/znc/moddata/log/libera/libera/*/*.log";
      frequency = "daily";
      minage = 3;
      su = "znc znc";
      rotate = 9000;
      compress = true;
      nocreate = true;
    };

    mosquitto = {
      enable = true;
      listeners = [{
        users.ian = {
          acl = [
            "readwrite #"
          ];
          hashedPasswordFile = "/etc/mosquitto_passwd";
        };
      }];
    };
  };

  security.acme = {
    defaults.email = import ../../common/email.nix {};
    acceptTerms = true;
  };

  systemd.services.pmbridge = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    environment = {
      PASSWORD_STORE_DIR = "/home/ian/.local/share/password-store";
    };
    path = [
      pkgs.protonmail-bridge
      pkgs.pass
    ];
    script = "protonmail-bridge -n";
  };

  systemd.services.pre-nginx = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    wantedBy = [ "nginx.service" ];
    path = [
      pkgs.coreutils
    ];
    script = ''
      mkdir -p /var/www
      chown nginx:nginx /var/www
    '';
  };

  systemd.services.freshrss-config = {
    environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
  };
  systemd.services.freshrss-updater = {
    environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
    startAt = pkgs.lib.mkForce "hourly";
  };

  systemd.services.invidious.serviceConfig = {
    Restart = pkgs.lib.mkForce "always";
    RuntimeMaxSec = pkgs.lib.mkForce "1h";
  };
}
