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
      enable = false;
      dockerCompat = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {};
    };
  };
}
