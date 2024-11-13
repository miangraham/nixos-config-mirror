{ pkgs, lib, inputs, config, ... }:
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.my.user = with lib.types; {
    enable = mkOption {
      type = bool;
      default = true;
      description = mdDoc "Whether to enable my user settings.";
    };
  };

  config = mkIf config.my.user.enable (import ./user.nix { inherit pkgs inputs config; });
}
