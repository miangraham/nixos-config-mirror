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
    libvirtd.enable = true;
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
