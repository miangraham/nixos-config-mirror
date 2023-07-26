{ config, pkgs, inputs, ... }:
let
  network = "futabanet";
  extraOptions = [
    "--pull=always"
    # "--network=${network}"
  ];
  environment = {
    TZ = "Asia/Tokyo";
  };
in
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.oci-containers.backend = "podman";

  # systemd.services."init-docker-network-${network}" = {
  #   description = "Create docker network bridge: ${network}";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig.Type = "oneshot";
  #   script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
  #            in ''
  #              # Put a true at the end to prevent getting non-zero return code, which will
  #              # crash the whole service.
  #              check=$(${dockercli} network ls | grep "${network}" || true)
  #              if [ -z "$check" ]; then
  #                ${dockercli} network create ${network}
  #              else
  #                echo "${network} already exists in docker"
  #              fi
  #            '';
  # };

  virtualisation.oci-containers.containers = {
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
