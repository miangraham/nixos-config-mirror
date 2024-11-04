{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    inherit borgbackup;

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };
  };
}
