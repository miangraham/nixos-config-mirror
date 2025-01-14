{ config, pkgs, inputs, ... }:
let
  network = "futabanet";
  extraOptions = [
    "--pull=missing"
    "--network=${network}"
  ];
  environment = {
    TZ = "Asia/Tokyo";
  };
in
{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
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
    homeassistant = {
      inherit environment extraOptions;
      # 2025.1.0
      image = "ghcr.io/home-assistant/home-assistant@sha256:7db850eff6b858b6d01860cd76a10d993861f9bff140de85734ce01d153a62ca";
      ports = [ "8091:8123" ];
      volumes = [
        "/srv/home-assistant:/config"
        "/run/dbus:/run/dbus:ro"
      ];
    };

    reddit-top-rss = {
      inherit environment extraOptions;
      # 2023.05.11
      image = "johnny5w/reddit-top-rss@sha256:f898b5b2643cdfa9bd741a8255e185a05b9ba66f969448c6672884aa187c9cb0";
      ports = [ "8089:8080" ];
      dependsOn = [];
      environmentFiles = [ /etc/reddit-top-rss/env ];
    };
  };
}
