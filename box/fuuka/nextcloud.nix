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
      enable = true;
      hostName = "nextcloud";
      package = pkgs.nextcloud28;
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "512M";
      https = false;
      phpOptions."opcache.interned_strings_buffer" = "16";
      autoUpdateApps.enable = false;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts deck maps notes onlyoffice tasks qownnotesapi;
      };
      config = {
        overwriteProtocol = "http";
        defaultPhoneRegion = "JP";
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/srv/nextcloud/adminpass";
      };
      extraOptions = {
        maintenance_window_start = 4;
        updatechecker = false;
      };
    };

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 05:00:00";
    };
  };
}
