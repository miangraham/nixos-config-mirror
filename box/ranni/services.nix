{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
  yt-dlp = import ../../home/yt-dlp.nix { inherit pkgs inputs; };
in
{
  services = {
    inherit borgbackup;

    navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/music";
        ScanSchedule = "@daily";
      };
    };

    syncthing.guiAddress = "0.0.0.0:8384";

    pipewire.enable = pkgs.lib.mkForce false;
  };

  systemd.services.pueue = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      yt-dlp
      pkgs.pueue
      pkgs.aria2
    ];
    script = "pueued -v";
  };
}
