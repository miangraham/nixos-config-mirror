{ pkgs, inputs, config, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  nix = {
    sshServe = {
      enable = true;
      protocol = "ssh-ng";
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcbC9h0gXGiyRCKE4Pj8jJ4loQ89QyeG7m3H2hLm6Fc ian@futaba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9bJ3HUVayNr8yYcE5WO/geJD7wjOmtYx+Nc5hcR7DS root@futaba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtZ9GKY548o3w65T0HAQjULyuKthQzenZ36LO18brZo ian@rin"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfZ7KtcLJWYJTNcoj2fJM9orUo/CJAQmpXihBCU6SSE root@rin"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVoASwk1Nn4Tf6DZIqS93E3k03wcoXWl4+dPGwvMMbm ian@ranni"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0pYB5bXpXNJKiW41KnhxKpvGm0h6+y13I2d9CR009Y root@ranni"
      ];
    };
    extraOptions = ''
      secret-key-files = /var/keys/nix-cache-key.priv
    '';
  };

  services = {
    inherit borgbackup;

    flatpak.enable = false;

    redis.servers.dev = {
      enable = true;
      port = 6379;
    };

    nebula.networks.asgard = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/nene.crt";
      key = "/etc/nebula/nene.key";
      lighthouses = [ "192.168.100.128" ];
      relays = [ "192.168.100.128" ];
      staticHostMap = {
        "192.168.100.128" = [
          "192.168.0.128:4242"
          "122.249.92.87:4242"
        ];
      };
      firewall = {
        inbound = [
          { port = "any"; proto = "icmp"; host = "any"; }
          { port = 22; proto = "tcp"; host = "any"; }
        ];
        outbound =  [ { port = "any"; proto = "any"; host = "any"; } ];
      };
      settings.preferred_ranges = [ "192.168.0.0/24" ];
    };

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
