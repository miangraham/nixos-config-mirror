{ config, pkgs, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    adguardhome = {
      enable = false;
      port = 9090;
    };

    # box specific due to ACME, rip
    nginx = {
      enable = true;
      user = "nginx";
      virtualHosts = {
        futaba = {
          serverName = "192.168.0.128";
          root = "/var/www";
        };

        # rss-bridge = {
        #   serverName = "rss-bridge";
        #   root = "${pkgs.rss-bridge}";

        #   locations."/" = {
        #     tryFiles = "$uri /index.php$is_args$args";
        #   };

        #   locations."~ ^/index.php(/|$)" = {
        #     extraConfig = ''
        #       include ${pkgs.nginx}/conf/fastcgi_params;
        #       fastcgi_split_path_info ^(.+\.php)(/.+)$;
        #       fastcgi_pass unix:${config.services.phpfpm.pools.${config.services.rss-bridge.pool}.socket};
        #       fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #       fastcgi_param RSSBRIDGE_DATA ${config.services.rss-bridge.dataDir};
        #     '';
        #   };
        # };
      };
    };

    rss-bridge = {
      enable = false;
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

    navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/music";
        ScanSchedule = "@daily";
      };
    };

    smokeping = {
      enable = true;
      hostName = "futaba";
      host = null;
      probeConfig = ''
          + FPing
          binary = ${config.security.wrapperDir}/fping
          + FPing6
          binary = ${config.security.wrapperDir}/fping
      '';
      targetConfig = ''
          probe = FPing
          menu = Top
          title = Ping Graphs
          remark = WAH
          + Local
          menu = Local
          title = Local Network
          ++ LocalMachine
          menu = Local Machine
          title = This host
          host = localhost
          ++ Nene
          menu = Nene
          title = Nene
          host = nene
          + Remote
          menu = Remote
          title = Remote
          ++ SpeedTest
          menu = SpeedTest
          title = SpeedTest
          host = www.speedtest.net
          ++ CloudflareDNS
          menu = CloudflareDNS
          title = CloudflareDNS
          host = 1.1.1.1
          ++ Steam
          menu = Steam
          title = Steam
          host = store.steampowered.com
          ++ Misaka
          menu = Misaka
          title = Misaka
          host = misaka.io
          ++ AmazonJP
          menu = AmazonJP
          title = AmazonJP
          host = amazon.co.jp
      '';
    };
  };

  systemd.services.pre-nginx = {
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

  systemd.services.rss-refresh = {
    serviceConfig.Type = "oneshot";
    path = [
      pkgs.curl
    ];
    script = "curl 'http://localhost:8088/i/?c=feed&a=actualize&ajax=1'";
  };
  systemd.timers.rss-refresh = {
    wantedBy = [ "timers.target" ];
    partOf = [ "rss-refresh.service" ];
    timerConfig.OnCalendar = "*-*-* *:00:00";
  };
}
