{ pkgs, config, lib, inputs, ... }:
with lib;
let
  cfg = config.my.gaming;
in
{
  options.my.gaming = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my gaming environment.";
    };
  };

  config = mkIf cfg.enable (import ./gaming.nix { inherit pkgs config inputs; });
}
