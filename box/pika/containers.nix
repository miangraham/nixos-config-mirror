{ config, pkgs, inputs, ... }:
let
  extraOptions = [
    "--pull=missing"
  ];
  environment = {
    TZ = "Asia/Tokyo";
  };
in
{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {
        uptime-kuma = {
          inherit environment extraOptions;
          # 1.23.11
          image = "louislam/uptime-kuma@sha256:48c17e48b96c17ee09f613c8c115dc05bc0bdc52cdf1ede6f634ba3798a7171e";
          ports = [ "3001:3001" ];
          volumes = [
            "/srv/uptime-kuma:/app/data"
          ];
        };
      };
    };
  };
  # Network slow start hack
  systemd.services.podman.serviceConfig.ExecStartPre = [ "/bin/sh -c 'until ${pkgs.bind.host}/bin/host ian.tokyo; do sleep 10; done'" ];
}
