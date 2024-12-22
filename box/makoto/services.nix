{ config, pkgs, inputs, ... }:
let
  unstable = import ../../common/unstable.nix { inherit pkgs inputs; };
in
{
  imports = [ "${inputs.unstable}/nixos/modules/services/matrix/conduwuit.nix" ];

  services = {
    conduwuit = {
      enable = true;
      package = unstable.conduwuit;
      settings = {
        global = {
          server_name = "rainingmessages.dev";
          address = [ "0.0.0.0" ];
          allow_registration = false;
          allow_federation = true;
        };
      };
    };

    scrutiny = {
      enable = true;
      openFirewall = true;
      collector.enable = true;
      settings.web.listen.port = 8099;
    };
  };
}
