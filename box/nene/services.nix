{ pkgs, inputs, config, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  nix = {
    sshServe = {
      enable = false;
      protocol = "ssh-ng";
      keys = [];
    };
    extraOptions = ''
      secret-key-files = /var/keys/nix-cache-key.priv
    '';
  };

  services = {
    inherit borgbackup;

    flatpak.enable = true;

    rabbitmq = {
      enable = true;
      listenAddress = "0.0.0.0";
      configItems = {
        "loopback_users.guest" = "false";
      };
    };

    redis.servers.dev = {
      enable = true;
      port = 6379;
      bind = null;
      settings = {
        protected-mode = "no";
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    # vikunja = {
    #   enable = true;
    #   database.type = "sqlite";
    #   frontendScheme = "http";
    #   frontendHostname = "localhost";
    # };
    # nginx.enable = true;

    # box specific due to ACME, rip
    # nginx = {
    #   enable = false;
    #   user = "nginx";
    #   virtualHosts = {
    #     nene = {
    #       serverName = "localhost";
    #       locations."/" = {
    #         root = "/var/www";
    #         # return = "404";
    #       };
    #     };
    #   };
    # };

    # dicod = {
    #   enable = false;
    #   dictdDBs = with pkgs.dictdDBs; [
    #     eng2jpn
    #     jpn2eng
    #   ];

    #   guileDBs = [
    #     moby
    #   ];
    # };
  };

  security.sudo.extraRules = [{
    users = ["ian"];
    commands = [{
      command = "/run/current-system/sw/bin/systemctl restart dicod"; options = [ "NOPASSWD" ];
    }];
  }];

  # systemd.services.monitor-song-changes = {
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "ian";
  #   };
  #   wantedBy = [ "graphical-session.target" ];
  #   path = [
  #     pkgs.coreutils
  #     pkgs.inotify-tools
  #   ];
  #   script = "/home/ian/.bin/monitorSongChanges.sh";
  # };
}
