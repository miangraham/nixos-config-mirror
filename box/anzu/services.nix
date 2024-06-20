{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  # borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    syncthing.guiAddress = "0.0.0.0:8384";

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };

    vikunja = {
      enable = true;
      database.type = "sqlite";
      frontendScheme = "http";
      frontendHostname = "anzu";
    };
  };
}
