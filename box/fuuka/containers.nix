{ config, pkgs, inputs, ... }:
let
  extraOptions = [
    "--pull=always"
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
      containers = {};
    };
  };
}
