{ pkgs, config, inputs, ... }:
{
  programs.steam.enable = true;

  home-manager.users.ian.home.packages = with pkgs; [
    mame.tools
    (pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
        pcsx-rearmed
        snes9x
        swanstation
      ];
    })
  ];
}
