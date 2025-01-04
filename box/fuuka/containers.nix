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
          # 0.10.17
          image = "ghcr.io/gethomepage/homepage@sha256:b261c981a866a0e287205394bf365bd8cdb9152469a85ec569d7bfcd7812cf14";
          ports = [ "7575:3000" ];
          volumes = [
            "/srv/homepage:/app/config"
          ];
        };
      };
    };
  };
}
