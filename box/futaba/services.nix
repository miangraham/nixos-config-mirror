{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  blocky = import ./blocky.nix { inherit pkgs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  # Pull invidious module from unstable for new hmac key settings. Remove after 23.11.
  disabledModules = [ "services/web-apps/invidious.nix" ];
  imports = [ "${inputs.unstable}/nixos/modules/services/web-apps/invidious.nix" ];

  services = {
    inherit blocky borgbackup;

    openssh.settings.PasswordAuthentication = false;

    syncthing.guiAddress = "0.0.0.0:8384";

    endlessh = {
      enable = true;
      openFirewall = true;
    };

    sshguard = {
      enable = true;
      blocktime = 3600;
      detection_time = 3600;
      attack_threshold = 5;
      blacklist_threshold = 20;
      whitelist = [ "192.168.0.0/16" ];
    };

    freshrss = {
      enable = true;
      baseUrl = "http://freshrss";
      dataDir = "/srv/freshrss/data";
      defaultUser = "ian";
      passwordFile = "/srv/freshrss/freshrss_admin_phrase";
    };
    phpfpm.pools.freshrss.phpEnv.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";

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

    nebula.networks.asgard = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      isLighthouse = true;
      isRelay = true;
      firewall = {
        inbound = [
          { port = "any"; proto = "icmp"; host = "any"; }
          { port = 22; proto = "tcp"; host = "any"; }
          { port = 80; proto = "tcp"; host = "any"; }
        ];
        outbound =  [ { port = "any"; proto = "any"; host = "any"; } ];
      };
      settings = {
        preferred_ranges = [ "192.168.0.0/24" ];
      };
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
          extraConfig = ''
            charset utf-8;
          '';
        };
        "ian.tokyo" = {
          serverName = "ian.tokyo";
          root = "/var/www";
          addSSL = true;
          enableACME = true;
          extraConfig = ''
            charset utf-8;
          '';
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
      # extraSettingsFile = "/etc/invidious/config.yml";
    };

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
  };

  security.acme = {
    defaults.email = import ../../common/email.nix {};
    acceptTerms = true;
  };

  systemd.services = {
    freshrss-config = {
      environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
    };
    freshrss-updater = {
      environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
      startAt = pkgs.lib.mkForce "hourly";
    };

    invidious.serviceConfig = {
      Restart = pkgs.lib.mkForce "always";
      RuntimeMaxSec = pkgs.lib.mkForce "1h";
    };

    pre-nginx = {
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
  };
}
