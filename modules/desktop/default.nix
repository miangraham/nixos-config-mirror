{ pkgs, config, lib, inputs, ... }:
with lib;
let
  cfg = config.my.desktop;
in
{
  options.my.desktop = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my desktop environment.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (import ./desktop-system.nix { inherit pkgs config inputs; })
    { home-manager.users.ian = import ./desktop-home.nix { inherit pkgs config inputs; }; }
  ]);
}
