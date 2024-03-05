{ config, pkgs, inputs, ... }:
let
  blocky = import ../futaba/blocky.nix { inherit pkgs; };
  nginx = import ./nginx.nix { inherit pkgs; };
in
{
  services = {
    inherit blocky nginx;
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
