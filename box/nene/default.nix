{ ... }:
let
  pkgs = import ../../common/stable.nix {};
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
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

  # box specific due to ACME, rip
  services.nginx = {
    enable = true;
    user = "nginx";
    virtualHosts."testlocal.ian.tokyo" = {
      root = "/var/www";
      addSSL = true;
      enableACME = true;
    };
  };
  security.acme = {
    email = "spamisevil@ijin.net";
    acceptTerms = true;
  };

  services.znc = {
    enable = true;
    confOptions = {
      passBlock = "";
    };
    # extraFlags = [ "--debug" ];
  };

  services.searx = {
    enable = true;
    settings = {
      server.port = 8989;
      server.bind_address = "0.0.0.0";
      server.secret_key = "@SEARX_SECRET_KEY@";
    };
    environmentFile = /home/ian/.config/searx/env;
  };

  systemd.services.twitter-expire-favorites = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.t}/bin/t favorites -l --profile=/home/ian/.trc \
      | ${pkgs.gawk}/bin/awk '{print $1}' \
      | xargs -r ${pkgs.t}/bin/t delete favorite --force --profile=/home/ian/.trc
    '';
  };
  systemd.timers.twitter-expire-favorites = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-expire-favorites.service" ];
    timerConfig.OnCalendar = "Sun 06:00";
  };

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
