{ config, pkgs, inputs, ... }:
let
  blocky = import ../futaba/blocky.nix { inherit pkgs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit blocky borgbackup;

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
      enable = false;
      openFirewall = true;
    };

    syncthing.guiAddress = "0.0.0.0:8384";
  };

  # systemd.services.pmbridge = {
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "ian";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  #   environment = {
  #     PASSWORD_STORE_DIR = "/home/ian/.local/share/password-store";
  #   };
  #   path = [
  #     pkgs.protonmail-bridge
  #     pkgs.pass
  #   ];
  #   script = "protonmail-bridge -n";
  # };

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
