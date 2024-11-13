{ pkgs, config, lib, inputs, ... }:
with lib;
let
  cfg = config.my.tablet;
in
{
  options.my.tablet = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my tablet environment.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (import ./tablet-system.nix { inherit pkgs config inputs; })
    { home-manager.users.ian = import ./tablet-home.nix { inherit pkgs config inputs; }; }
  ]);
}
