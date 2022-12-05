{ config, pkgs, inputs, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    endlessh = {
      enable = true;
      openFirewall = true;
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
        invid = {
          enableACME = false;
          forceSSL = false;
        };
      };
    };

    invidious = {
      enable = true;
      package = inputs.invid-testing.legacyPackages.x86_64-linux.invidious;
      domain = "invid";
      port = 9999;
      nginx.enable = true;
      database.createLocally = true;
      settings = {
        registration_enabled = true;
        login_enabled = true;
        captcha_enabled = false;
        popular_enabled = false;
        default_user_preferences = {
          region = "JP";
          related_videos = false;
          comments = [ "" "" ];
          feed_menu = [ "Subscriptions" "none" "none" "none" ];
          default_home = "Subscriptions";
        };
      };
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

  systemd.services.searx.serviceConfig = {
    RuntimeMaxSec = "30m";
    Restart = "always";
  };
}
