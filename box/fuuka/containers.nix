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
      dockerCompat = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {
        homepage = {
          inherit environment extraOptions;
          # 0.8.10
          image = "ghcr.io/gethomepage/homepage@sha256:fc0d6e8b469ea8756d7c5bc542eb5c89064b9c47c3fa85f19b70a695c65cb782";
          ports = [ "7575:3000" ];
          volumes = [
            "/srv/homepage:/app/config"
          ];
        };
      };
    };
  };
}
