{ config, pkgs, inputs, ... }:
let
  # unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
in
{
  services = {
    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };
  };
}
