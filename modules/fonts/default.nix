{ pkgs, lib, config, ... }:
with lib;
{
  options.my.fonts = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my font settings.";
    };
  };

  config = mkIf config.my.fonts.enable {
    fonts = import ./fonts.nix { inherit pkgs; };
  };
}
