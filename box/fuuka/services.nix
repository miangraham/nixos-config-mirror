{ config, pkgs, inputs, ... }:
let
  blocky = import ../futaba/blocky.nix { inherit pkgs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
  nginx = import ./nginx.nix { inherit pkgs; };
in
{
  services = {
    inherit blocky borgbackup nginx;

    dendrite = {
      enable = true;
      loadCredential = [
        "private_key:/etc/dendrite/dendrite.key"
        "shared_secret:/etc/dendrite/shared_secret"
      ];
      settings = {
        global.server_name = "graham.tokyo";
        global.private_key = "$CREDENTIALS_DIRECTORY/private_key";
        client_api.registration_shared_secret = "$CREDENTIALS_DIRECTORY/shared_secret";
        app_service_api.database.connection_string = "file:appserviceapi.db";
      };
    };
  };

  systemd.services = {
    pre-nginx = {
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
  };
}
