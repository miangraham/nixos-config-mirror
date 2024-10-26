{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
  # borgbackup = import ./backup.nix { inherit pkgs; };
in
{
  services = {
    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = false;
      settings.web.listen.port = 8099;
    };
  };
}
