{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    syncthing.guiAddress = "0.0.0.0:8384";

    scrutiny = {
      enable = false;
      openFirewall = true;
      collector.enable = false;
      settings.web.listen.port = 8099;
    };

    vikunja = {
      enable = false;
      database.type = "sqlite";
      frontendScheme = "https";
      frontendHostname = "todo.ian.tokyo";
      settings = {
        service = {
          enableemailreminders = false;
          enableregistration = false;
          enableuserdeletion = false;
          timezone = "Asia/Tokyo";
        };
      };
    };
  };
}
