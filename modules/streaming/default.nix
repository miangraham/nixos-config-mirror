{ pkgs, config, lib, inputs, ... }:
with lib;
let
  cfg = config.my.streaming;
in
{
  options.my.streaming = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my streaming environment.";
    };
  };

  config = mkIf cfg.enable (import ./streaming.nix { inherit pkgs config inputs; });
}
