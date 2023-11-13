{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  blocky = import ./blocky.nix { inherit pkgs; };
  borgbackup = import ./backup.nix { inherit pkgs; };

  admin_email = import ../../common/email.nix {};
  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "graham.tokyo"
    }
  '';

  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://graham.tokyo"
      }
    }
  '';
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

    matrix-conduit = {
      enable = false;
      settings.global = {
        server_name = "graham.tokyo";
        database_backend = "rocksdb";
        allow_federation = false;
        allow_registration = false;
      };
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
          { port = 8091; proto = "tcp"; host = "any"; } # HA
          { port = 8384; proto = "tcp"; host = "any"; } # syncthing
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
      # upstreams = {
      #   "backend_conduit" = {
      #     servers = {
      #       "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = {};
      #     };
      #   };
      # };
      virtualHosts = {
        futaba = {
          serverName = "192.168.0.128";
          root = "/var/www";
          default = true;
          extraConfig = ''
            charset utf-8;
          '';
        };
        invid = {
          enableACME = false;
          forceSSL = false;
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
        # "graham.tokyo" = {
        #   serverName = "graham.tokyo";
        #   forceSSL = true;
        #   enableACME = true;
          # listen = [
          #   {
          #     addr = "0.0.0.0";
          #     port = 443;
          #     ssl = true;
          #   }
          #   {
          #     addr = "[::]";
          #     port = 443;
          #     ssl = true;
          #   }
          #   {
          #     addr = "0.0.0.0";
          #     port = 8448;
          #     ssl = true;
          #   }
          #   {
          #     addr = "[::]";
          #     port = 8448;
          #     ssl = true;
          #   }
          # ];
          # extraConfig = ''
          #   merge_slashes off;
          # '';
          # locations."/_matrix/" = {
          #   proxyPass = "http://backend_conduit$request_uri";
          #   proxyWebsockets = true;
          #   extraConfig = ''
          #     proxy_set_header Host $host;
          #     proxy_buffering off;
          #   '';
          # };
          # locations."=/.well-known/matrix/server" = {
          #   # Use the contents of the derivation built previously
          #   alias = "${well_known_server}";

          #   extraConfig = ''
          #     # Set the header since by default NGINX thinks it's just bytes
          #     default_type application/json;
          #   '';
          # };
          # locations."=/.well-known/matrix/client" = {
          #   # Use the contents of the derivation built previously
          #   alias = "${well_known_client}";

          #   extraConfig = ''
          #     # Set the header since by default NGINX thinks it's just bytes
          #     default_type application/json;

          #     # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
          #     add_header Access-Control-Allow-Origin "*";
          #   '';
          # };
        # };
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
