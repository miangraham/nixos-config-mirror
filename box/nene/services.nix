{ pkgs, inputs, config, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
in
{
  imports = [ "${inputs.unstable}/nixos/modules/services/web-apps/immich.nix" ];

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

    flatpak.enable = false;
    immich = {
      enable = true;
      package = unstable.immich;
    };

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

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };
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
