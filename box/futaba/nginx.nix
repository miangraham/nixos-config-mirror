{ config, pkgs, ... }:
let
  wellKnownServer = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "graham.tokyo:443"
    }
  '';
  wellKnownClient = pkgs.writeText "well-known-matrix-client" ''
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
  upstreams = {
    "backend_matrix" = {
      servers = {
        "fuuka:8008" = {};
      };
    };
  };
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
    # "todo.ian.tokyo" = {
    #   serverName = "todo.ian.tokyo";
    #   forceSSL = true;
    #   enableACME = true;
    #   locations."/".proxyPass = "http://anzu:3456";
    #   locations."=/robots.txt".extraConfig = robotsConf;
    # };
    "graham.tokyo" = {
      serverName = "graham.tokyo";
      forceSSL = true;
      enableACME = true;
      listen = [
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
      extraConfig = ''
        merge_slashes off;
      '';
      locations."/_matrix/" = {
        proxyPass = "http://backend_matrix$request_uri";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_read_timeout 600;
        '';
      };
      locations."=/robots.txt".extraConfig = robotsConf;
      locations."=/.well-known/matrix/server" = {
        alias = "${wellKnownServer}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${wellKnownClient}";
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
