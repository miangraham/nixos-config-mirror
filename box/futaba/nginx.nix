{ config, pkgs, ... }:
let
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
      addSSL = true;
      enableACME = true;
      extraConfig = ''
        charset utf-8;
      '';
    };
    "graham.tokyo" = {
      serverName = "graham.tokyo";
      forceSSL = true;
      enableACME = true;
      listen = [
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
          proxy_buffering off;
        '';
      };
      locations."=/.well-known/matrix/server" = {
        alias = "${well_known_server}";
        extraConfig = ''
          # Set the header since by default NGINX thinks it's just bytes
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${well_known_client}";
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
