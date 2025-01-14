{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  nginx = import ./nginx.nix { inherit pkgs; };
in
{
  services = {
    inherit nginx;

    dendrite = {
      enable = true;
      loadCredential = [
        "private_key:/etc/dendrite/dendrite.key"
        "shared_secret:/etc/dendrite/shared_secret"
      ];
      settings = {
        global = {
          server_name = "graham.tokyo";
          private_key = "$CREDENTIALS_DIRECTORY/private_key";
          report_stats.enabled = false;
          cache = {
            max_size_estimated = "1gb";
            max_age = "1h";
          };
          dns_cache = {
            enabled = true;
            cache_size = 1024;
            cache_lifetime = "10m";
          };
        };
        logging = [{
          type = "std";
          level = "warn";
        }];
        app_service_api.database.connection_string = "file:appserviceapi.db";
        client_api = {
          guests_disabled = true;
          registration_disabled = true;
          # registration_shared_secret = "$CREDENTIALS_DIRECTORY/shared_secret";
        };
        federation_api.key_perspectives = [{
          server_name = "matrix.org";
          keys = [{
            key_id = "ed25519:auto";
            public_key = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          } {
            key_id = "ed25519:a_RXGa";
            public_key = "l8Hft5qXKn1vfHrg3p4+W8gELQVo8N13JkluMfmn2sQ";
          }];
        }];
      };
    };

    gotosocial = {
      enable = true;
      openFirewall = true;
      setupPostgresqlDB = true;
      settings = {
        application-name = "rainingmessages";
        host = "social.rainingmessages.dev";
        account-domain = "rainingmessages.dev";
        protocol = "https";
        bind-address = "0.0.0.0";
        port = 8080;
        trusted-proxies = [ "192.168.0.128" ];
        instance-inject-mastodon-version = true;
        instance-languages = [ "en" "ja" ];
        instance-federation-mode = "blocklist";
      };
    };

    minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      openFirewall = true;
      serverProperties = {
        difficulty = "normal";
        level-name = "fuuka";
        level-seed = "fuuka";

        max-players = 4;
        motd = "Hello from NixOS";
        snooper-enabled = false;
      };
    };

    postgresql.package = pkgs.postgresql_16;

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 05:00:00";
    };

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };

    thelounge = {
      enable = true;
      extraConfig = {
        reverseProxy = false;
        defaults = {
          name = "Libera.Chat";
          host = "irc.libera.chat";
          port = 6697;
          tls = true;
          rejectUnauthorized = true;
        };
      };
      plugins = with pkgs.theLoungePlugins.themes; [
        dracula
        solarized
        zenburn
      ];
    };

    wastebin = {
      enable = true;
      secretFile = "/etc/wastebin/env";
      settings = {
        WASTEBIN_BASE_URL = "https://bin.ian.tokyo";
        WASTEBIN_TITLE = "bin.ian.tokyo";
      };
    };
  };

  systemd.services = {
    pre-nginx = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      wantedBy = [ "nginx.service" ];
      path = [ pkgs.coreutils ];
      script = ''
        mkdir -p /var/www
        chown nginx:nginx /var/www
      '';
    };

    pre-thelounge = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      before = [ "thelounge.service" ];
      wantedBy = [ "thelounge.service" ];
      path = [ pkgs.coreutils ];
      script = ''
        until ${pkgs.bind.host}/bin/host irc.libera.chat; do sleep 10; done
      '';
    };
  };
}
