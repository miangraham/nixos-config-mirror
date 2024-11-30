{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  forgesrv = config.services.forgejo.settings.server;
in
{
  # imports = [ "${inputs.unstable}/nixos/modules/services/web-apps/immich.nix" ];

  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";
      dump.enable = true;
      settings = {
        service.DISABLE_REGISTRATION = true;
        server = {
          DOMAIN = "git.ian.tokyo";
          ROOT_URL = "https://${forgesrv.DOMAIN}/";
          HTTP_PORT = 3000;
        };
      };
    };

    # unstable mixin broken by https://github.com/NixOS/nixpkgs/pull/345327, not actively using so wait for 24.11
    # immich = {
    #   enable = true;
    #   package = unstable.immich;
    #   host = "0.0.0.0";
    #   openFirewall = true;
    # };

    searx = {
      enable = true;
      environmentFile = /home/ian/.config/searx/env;
      package = pkgs.searxng;
      redisCreateLocally = true;
      settings = {
        server.port = 8989;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
        general = {
          debug = false;
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = false;
        };
        ui = {
          infinite_scroll = false;
        };
      };
    };

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

    vikunja = {
      enable = true;
      database.type = "sqlite";
      frontendScheme = "https";
      frontendHostname = "todo.ian.tokyo";
      settings = {
        service = {
          enableemailreminders = false;
          enableregistration = false;
          enableuserdeletion = false;
          timezone = "Asia/Tokyo";
        };
      };
    };
  };
}
