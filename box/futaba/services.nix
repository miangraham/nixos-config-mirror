{ config, ... }:
let
  pkgs = import ../../common/stable.nix {};
in
{
  services = {
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
  };

}
