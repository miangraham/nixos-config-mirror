{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    syncthing.guiAddress = "0.0.0.0:8384";

    dnsmasq = {
      enable = false;
      servers = [
        "2404:1a8:7f01:b::3"
        "2404:1a8:7f01:a::3"
        "192.168.0.1"
      ];
    };

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
          default = true;
        };
        "ian.tokyo" = {
          serverName = "ian.tokyo";
          root = "/var/www";
          addSSL = true;
          enableACME = true;
        };
        invid = {
          enableACME = false;
          forceSSL = false;
        };
      };
    };

    invidious = {
      enable = true;
      package = unstable.invidious;
      domain = "invid";
      port = 9999;
      nginx.enable = true;
      database.createLocally = true;
      settings = {
        registration_enabled = true;
        login_enabled = true;
        captcha_enabled = false;
        popular_enabled = false;
        enable_user_notifications = false;
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
      enable = false;
      settings = {
        server.port = 8989;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
      };
      environmentFile = /home/ian/.config/searx/env;
    };

    navidrome = {
      enable = false;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/music";
        ScanSchedule = "@daily";
      };
    };

    freshrss = {
      enable = true;
      baseUrl = "http://freshrss";
      dataDir = "/srv/freshrss/data";
      defaultUser = "ian";
      passwordFile = "/srv/freshrss/freshrss_admin_phrase";
    };
    phpfpm.pools.freshrss.phpEnv.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";

    libreddit = {
      enable = false;
      port = 8091;
      openFirewall = true;
    };

    nextcloud = {
      enable = false;
      package = pkgs.nextcloud25;
      hostName = "nextcloud";
      https = false;
      home = "/srv/nextcloud";
      appstoreEnable = false;
      config = {
        adminuser = "admin";
        adminpassFile = "/srv/nextcloud/nextcloud-admin-pass";
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

  security.acme = {
    defaults.email = import ../../common/email.nix {};
    acceptTerms = true;
  };

  systemd.services.pmbridge = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    environment = {
      PASSWORD_STORE_DIR = "/home/ian/.local/share/password-store";
    };
    path = [
      unstable.protonmail-bridge
      pkgs.pass
    ];
    script = "protonmail-bridge -n";
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

  # systemd.services.searx.serviceConfig = {
  #   RuntimeMaxSec = "30m";
  #   Restart = "always";
  # };

  systemd.services.freshrss-config = {
    environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
  };
  systemd.services.freshrss-updater = {
    environment.FRESHRSS_THIRDPARTY_EXTENSIONS_PATH = "/srv/freshrss/extensions";
    startAt = pkgs.lib.mkForce "hourly";
  };
}
