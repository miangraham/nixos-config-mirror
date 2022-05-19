{ config, pkgs, ... }:
let
  backup = import ../../system/backup.nix {
    inherit pkgs;
    backupTime = "*-*-* *:04:00";
  };
  network = "futabanet";
in
{
  services = {
    inherit (backup) borgbackup;

    adguardhome = {
      enable = true;
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

  systemd.services."init-docker-network-${network}" = {
    description = "Create docker network bridge: ${network}";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
             in ''
               # Put a true at the end to prevent getting non-zero return code, which will
               # crash the whole service.
               check=$(${dockercli} network ls | grep "${network}" || true)
               if [ -z "$check" ]; then
                 ${dockercli} network create ${network}
               else
                 echo "${network} already exists in docker"
               fi
             '';
  };

  virtualisation.oci-containers.containers = {
    freshrss = {
      image = "freshrss/freshrss:latest";
      dependsOn = [];
      extraOptions = [
        "--pull=always"
        # "--device=/dev/ttyACM0:/dev/ttyACM0"
        "--network=${network}"
      ];
      ports = [
        "8088:80"
      ];
      volumes = [
        "/srv/freshrss/data:/var/www/FreshRSS/data"
        "/srv/freshrss/extensions:/var/www/FreshRSS/extensions"
      ];
      environment = {
        TZ = "Asia/Tokyo";
      };
    };
  };
}
