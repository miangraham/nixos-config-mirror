{ config, pkgs, ... }:
let
  listenToWebAndMatrix = [
    {
      addr = "0.0.0.0";
      port = 80;
    }
    {
      addr = "[::]";
      port = 80;
    }
    {
      addr = "0.0.0.0";
      port = 443;
      ssl = true;
    }
    {
      addr = "[::]";
      port = 443;
      ssl = true;
    }
    {
      addr = "0.0.0.0";
      port = 8448;
      ssl = true;
    }
    {
      addr = "[::]";
      port = 8448;
      ssl = true;
    }
  ];
  wellKnownMatrixServer = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "graham.tokyo:443"
    }
  '';
  wellKnownMatrixClient = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://graham.tokyo"
      }
    }
  '';
  robotsConf = ''
    add_header Content-Type text/plain;
    return 200 "User-agent: *\nDisallow: /\n";
  '';
in
{
  enable = true;
  user = "nginx";
  clientMaxBodySize = "40M";
  upstreams = {
    "backend_dendrite" = {
      servers = {
        "fuuka:8008" = {};
      };
    };
    "backend_conduwuit" = {
      servers = {
        "makoto:6167" = {};
      };
    };
  };
  virtualHosts = {
    futaba = {
      serverName = "192.168.0.128";
      # root = "/var/www";
      default = true;
      locations."/" = {
        return = "444";
      };
    };
    invid = {
      enableACME = false;
      forceSSL = false;
    };
    "ian.tokyo" = {
      serverName = "ian.tokyo";
      root = "/var/www";
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        charset utf-8;
      '';
      locations."=/robots.txt".extraConfig = robotsConf;
    };
    "bin.ian.tokyo" = {
      serverName = "bin.ian.tokyo";
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://fuuka:8088";
        extraConfig = ''
          limit_except GET HEAD {
            auth_basic secured;
            auth_basic_user_file /etc/nginx/wastebin.htpasswd;
          }
        '';
      };
      locations."=/robots.txt".extraConfig = robotsConf;
    };
    "git.ian.tokyo" = {
      serverName = "git.ian.tokyo";
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://anzu:3000";
      locations."=/robots.txt".extraConfig = robotsConf;
    };
    "todo.ian.tokyo" = {
      serverName = "todo.ian.tokyo";
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://anzu:3456";
      locations."=/robots.txt".extraConfig = robotsConf;
    };
    "rainingmessages.dev" = let
      wkmServer = pkgs.writeText "well-known-matrix-server" ''
        {
          "m.server": "rainingmessages.dev:443"
        }
      '';
      wkmClient = pkgs.writeText "well-known-matrix-client" ''
        {
          "m.homeserver": {
            "base_url": "https://rainingmessages.dev"
          }
        }
      '';
    in {
      serverName = "rainingmessages.dev";
      root = "/var/www";
      forceSSL = true;
      enableACME = true;
      listen = listenToWebAndMatrix;
      locations."=/robots.txt".extraConfig = robotsConf;
      locations."/_matrix/" = {
        proxyPass = "http://backend_conduwuit$request_uri";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_read_timeout 600;
        '';
      };
      locations."=/.well-known/matrix/server" = {
        alias = "${wkmServer}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${wkmClient}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;

          # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
          add_header Access-Control-Allow-Origin "*";
        '';
      };
      extraConfig = ''
        merge_slashes off;
        location /.well-known/webfinger {
          rewrite ^.*$ https://social.rainingmessages.dev/.well-known/webfinger permanent;
        }

        location /.well-known/host-meta {
            rewrite ^.*$ https://social.rainingmessages.dev/.well-known/host-meta permanent;
        }

        location /.well-known/nodeinfo {
            rewrite ^.*$ https://social.rainingmessages.dev/.well-known/nodeinfo permanent;
        }
      '';
    };
    "social.rainingmessages.dev" = {
      serverName = "social.rainingmessages.dev";
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "http://fuuka:8080";
      };
      locations."=/robots.txt".extraConfig = robotsConf;
    };
    "graham.tokyo" = {
      serverName = "graham.tokyo";
      forceSSL = true;
      enableACME = true;
      listen = listenToWebAndMatrix;
      extraConfig = ''
        merge_slashes off;
      '';
      locations."/_matrix/" = {
        proxyPass = "http://backend_dendrite$request_uri";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_read_timeout 600;
        '';
      };
      locations."=/robots.txt".extraConfig = robotsConf;
      locations."=/.well-known/matrix/server" = {
        alias = "${wellKnownMatrixServer}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${wellKnownMatrixClient}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;

          # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
          add_header Access-Control-Allow-Origin "*";
        '';
      };
    };
  };
}
