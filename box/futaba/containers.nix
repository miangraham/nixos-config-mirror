{ config, pkgs, ... }:
let
  network = "futabanet";
in
{
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
    freshrss = {
      image = "freshrss/freshrss@sha256:09e379a4c6046e29c26272d135abfb9b5078bbeb19eba0826741afe3f6f21815";
      dependsOn = [];
      extraOptions = [
        "--pull=always"
        # "--device=/dev/ttyACM0:/dev/ttyACM0"
        "--network=${network}"
      ];
      ports = [
        "8088:80"
      ];
      volumes = [
        "/srv/freshrss/data:/var/www/FreshRSS/data"
        "/srv/freshrss/extensions:/var/www/FreshRSS/extensions"
      ];
      environment = {
        TZ = "Asia/Tokyo";
      };
    };

    reddit-top-rss = {
      image = "johnny5w/reddit-top-rss@sha256:cb1ea08ab0be1a583f5d95105d0226f80804180c10843390ac0bf226701537df";
      dependsOn = [];
      extraOptions = [
        "--pull=always"
        "--network=${network}"
      ];
      ports = [
        "8089:8080"
      ];
      environment = {
        TZ = "Asia/Tokyo";
      };
    };
  };
}
