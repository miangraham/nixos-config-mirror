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
          # 0.8.8
          image = "ghcr.io/gethomepage/homepage@sha256:0f066a6d6fba3a810a85aa79a483302b0fee21139b67adaeb245edae5051f3e8";
          ports = [ "7575:3000" ];
          volumes = [
            "/srv/homepage:/app/config"
          ];
        };
      };
    };
  };
}
