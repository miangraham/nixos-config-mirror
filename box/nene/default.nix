{ config, ... }:
let
  pkgs = import ../../common/stable.nix {};
  filter-tweets = import ../../../filter-tweets/default.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
    ./twitter.nix
    ./services.nix
  ];
  system.stateVersion = "20.03";
  networking.hostName = "nene";
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    # "fs.inotify.max_user_instances" = 4096;
    # "net.ipv4.tcp_fin_timeout" = 10;
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 2222 8384 8443 8989 ];

  # virtualisation.oci-containers = {
  #   backend = "podman";
  #   containers = {
  #     whoogle = {
  #       image = "benbusby/whoogle-search";
  #       ports = ["127.0.0.1:5000:5000"];
  #       volumes = [
  #         "/var/db/isso:/db"
  #       ];
  #     };
  #   };
  # };
}
