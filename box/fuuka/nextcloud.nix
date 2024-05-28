{ pkgs, inputs, config, ... }:
{
  environment.systemPackages = [ config.services.nextcloud.occ ];

  services = {
    nginx.virtualHosts = {
      "nextcloud" = {
        forceSSL = false;
        enableACME = false;
      };
    };

    nextcloud = {
      enable = false;
      hostName = "nextcloud";
      package = pkgs.nextcloud29;
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "512M";
      https = false;
      phpOptions."opcache.interned_strings_buffer" = "16";
      autoUpdateApps.enable = false;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts deck maps notes;
      };
      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/srv/nextcloud/adminpass";
      };
      settings = {
        default_phone_region = "JP";
        maintenance_window_start = 4;
        overwriteprotocol = "http";
        updatechecker = false;
      };
    };

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 05:00:00";
    };
  };

  systemd.timers.nextcloud-cron.timerConfig.OnUnitActiveSec = pkgs.lib.mkForce "55m";
}
