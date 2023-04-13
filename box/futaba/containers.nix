{ config, pkgs, ... }:
let
  network = "futabanet";
  extraOptions = [
    "--pull=always"
    "--network=${network}"
  ];
  environment = {
    TZ = "Asia/Tokyo";
  };
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
    reddit-top-rss = {
      inherit environment extraOptions;
      image = "johnny5w/reddit-top-rss@sha256:cb1ea08ab0be1a583f5d95105d0226f80804180c10843390ac0bf226701537df";
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
  };
}
