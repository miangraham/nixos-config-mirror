{ pkgs, config, inputs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
  };

  home-manager.users.ian.home.packages = with pkgs; [
    carla
    lsp-plugins
    reaper
    tap-plugins
  ];
}
