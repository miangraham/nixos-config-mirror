{ config, pkgs, inputs, ... }:
let
  network = "futabanet";
  extraOptions = [
    "--pull=always"
    "--network=${network}"
  ];
  environment = {
    TZ = "Asia/Tokyo";
    REDDIT_USER_AGENT = "php:miangraham.reddit.rss:9.9.9";
  };
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
in
{
  virtualisation.docker = {
    enable = true;
    package = unstable.docker;
  };
  virtualisation.oci-containers.backend = "docker";

  systemd.services."init-docker-network-${network}" = {
    description = "Create docker network bridge: ${network}";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
             in ''
               # Put a true at the end to prevent getting non-zero return code, which will
               # crash the whole service.
               check=$(${dockercli} network ls | grep "${network}" || true)
               if [ -z "$check" ]; then
                 ${dockercli} network create ${network}
               else
                 echo "${network} already exists in docker"
               fi
             '';
  };

  virtualisation.oci-containers.containers = {
    reddit-top-rss = {
      inherit environment extraOptions;
      image = "ghcr.io/miangraham/reddit-top-rss@sha256:b231f880d9d3771a34d4b12be8cfb61d976144e8bb49524631099223a0b8f709";
      dependsOn = [];
      ports = [
        "8089:8080"
      ];
    };

    mercury-parser-api = {
      inherit environment extraOptions;
      image = "wangqiru/mercury-parser-api@sha256:da06e19694c85816b6c2f9870e66beaa03bbd0043d8a759b86e2bb16020ee5c2";
      dependsOn = [];
      ports = [
        "8090:3000"
      ];
    };

    homeassistant = {
      inherit environment extraOptions;
      image = "ghcr.io/home-assistant/home-assistant@sha256:a86ff5d05ce46520c53d67c8da55aba310de9b9b4ca8eead1ae0b5ab1c068f97";
      volumes = [
        "/srv/home-assistant:/config"
        "/run/dbus:/run/dbus:ro"
      ];
      ports = [ "8091:8123" ];
    };
  };
}
