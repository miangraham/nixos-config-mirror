{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  nginx = import ./nginx.nix { inherit config pkgs; };
in
{
  # Example pulling nixos module from unstable
  # disabledModules = [ "services/web-apps/invidious.nix" ];
  # imports = [ "${inputs.unstable}/nixos/modules/services/web-apps/invidious.nix" ];

  environment.systemPackages = [ pkgs.nebula ]; # for nebula-cert cmd

  services = {
    inherit nginx;

    openssh.settings.PasswordAuthentication = false;

    syncthing.guiAddress = "0.0.0.0:8384";

    sshguard = {
      enable = true;
      blocktime = 3600;
      detection_time = 3600;
      attack_threshold = 5;
      blacklist_threshold = 20;
      whitelist = [ "192.168.0.0/16" ];
    };

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
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
      ca = ../../modules/nebula-node/nebula-ca.crt;
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      isLighthouse = true;
      isRelay = true;
      firewall = {
        inbound = [
          { port = "any"; proto = "icmp"; host = "any"; }
          { port = 22; proto = "tcp"; host = "any"; }
          { port = 80; proto = "tcp"; host = "any"; }
          { port = 8091; proto = "tcp"; host = "any"; } # HA
          { port = 8092; proto = "tcp"; host = "any"; } # microbin
          { port = 8384; proto = "tcp"; host = "any"; } # syncthing
        ];
        outbound =  [ { port = "any"; proto = "any"; host = "any"; } ];
      };
      settings = {
        preferred_ranges = [ "192.168.0.0/24" ];
      };
    };

    invidious = {
      enable = true;
      package = pkgs.invidious;
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
        db.user = "invidious";
        default_user_preferences = {
          region = "JP";
          related_videos = false;
          comments = [ "" "" ];
          feed_menu = [ "Subscriptions" "none" "none" "none" ];
          default_home = "Subscriptions";
        };
      };
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

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 05:00:00";
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
