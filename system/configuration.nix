{ config, pkgs, lib, ... }:
{
  imports = [
    ../box/nene/default.nix
    ../common/overlays.nix
    ./bash.nix
    ./fonts.nix
    ./network.nix
    ./packages.nix
    ./sway.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  time.timeZone = "Asia/Tokyo";

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 100;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  nix.trustedUsers = ["@wheel"];

  users.users.ian = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio"];
  };

  hardware.pulseaudio.enable = true;

  services.openssh.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
  };
}
