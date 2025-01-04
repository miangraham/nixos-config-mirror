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
          # 1.23.16
          image = "louislam/uptime-kuma@sha256:431fee3be822b04861cf0e35daf4beef6b7cb37391c5f26c3ad6e12ce280fe18";
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
