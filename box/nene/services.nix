{ config, ... }:
let
  pkgs = import ../../common/stable.nix {};
  unstable = import ../../common/unstable.nix {};
  backup = import ../../system/backup.nix {
    inherit pkgs;
    backupTime = "*-*-* *:02:00";
  };
in
{
  services = {
    inherit (backup) borgbackup;

    # box specific due to ACME, rip
    nginx = {
      enable = true;
      user = "nginx";
      virtualHosts = {
        nene = {
          serverName = "localhost";
          locations."/" = {
            return = "404";
          };
        };

        "testlocal.ian.tokyo" = {
          serverName = "testlocal.ian.tokyo";
          root = "/var/www";
          addSSL = true;
          enableACME = true;
        };

        rss-bridge = {
          serverName = "rss-bridge";
          root = "${pkgs.rss-bridge}";

          locations."/" = {
            tryFiles = "$uri /index.php$is_args$args";
          };

          locations."~ ^/index.php(/|$)" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${config.services.rss-bridge.pool}.socket};
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param RSSBRIDGE_DATA ${config.services.rss-bridge.dataDir};
            '';
          };
        };
      };
    };

    rss-bridge = {
      enable = true;
      virtualHost = null;
      whitelist = [
        "DevTo"
        "Facebook"
        "GithubIssue"
        "Instagram"
        "Mastodon"
        "Pixiv"
        "Reddit"
        "Twitter"
        "Vimeo"
        "Wikipedia"
        "Youtube"
      ];
    };

    searx = {
      enable = true;
      settings = {
        server.port = 8989;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
      };
      environmentFile = /home/ian/.config/searx/env;
    };

    znc = {
      enable = true;
      confOptions = {
        passBlock = "";
      };
      # extraFlags = [ "--debug" ];
    };
  };

  security.acme = {
    email = "spamisevil@ijin.net";
    acceptTerms = true;
  };

  systemd.services.pueue = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      unstable.pueue
      unstable.yt-dlp
    ];
    script = "pueued -v";
  };
}
