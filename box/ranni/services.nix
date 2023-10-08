{ config, pkgs, inputs, ... }:
let
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    pipewire.enable = pkgs.lib.mkForce false;

    navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/music";
        ScanSchedule = "@daily";
      };
    };

    photoprism = {
      enable = false;
      address = "0.0.0.0";
      port = 8385;
      originalsPath = "/srv/pictures";
      passwordFile = "/var/lib/photoprism/admin-pass";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    syncthing.guiAddress = "0.0.0.0:8384";

    nebula.networks.asgard = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
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
  };

  systemd.services.pmbridge = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    environment = {
      PASSWORD_STORE_DIR = "/home/ian/.local/share/password-store";
    };
    path = [
      pkgs.protonmail-bridge
      pkgs.pass
    ];
    script = "protonmail-bridge -n";
  };

  systemd.services.pueue = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.yt-dlp
      pkgs.pueue
      pkgs.aria2
    ];
    script = "pueued -v";
  };
}
