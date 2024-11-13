{ pkgs, lib, config, ... }:
with lib;
{
  options.my.audio = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable my audio settings.";
    };
  };

  config = mkIf config.my.audio.enable {
    environment.systemPackages = [ pkgs.pulseaudio ];

    programs.noisetorch.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
  };
}
