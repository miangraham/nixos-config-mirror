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
        global = {
          server_name = "graham.tokyo";
          private_key = "$CREDENTIALS_DIRECTORY/private_key";
          cache = {
            max_size_estimated = "1gb";
            max_age = "1h";
          };
        };
        logging = [{
          type = "std";
          level = "warn";
        }];
        app_service_api.database.connection_string = "file:appserviceapi.db";
        client_api.registration_shared_secret = "$CREDENTIALS_DIRECTORY/shared_secret";
        federation_api.key_perspectives = [{
          server_name = "matrix.org";
          keys = [{
            key_id = "ed25519:auto";
            public_key = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          } {
            key_id = "ed25519:a_RXGa";
            public_key = "l8Hft5qXKn1vfHrg3p4+W8gELQVo8N13JkluMfmn2sQ";
          }];
        }];
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
