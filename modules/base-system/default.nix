{ pkgs, lib, inputs, config, ... }:
with lib;
{
  options.my.base-system = with lib.types; {
    enable = mkOption {
      type = bool;
      default = true;
      description = mdDoc "Whether to enable the base system.";
    };
  };

  config = mkIf config.my.base-system.enable (import ./base-system.nix { inherit pkgs inputs config; });
}
