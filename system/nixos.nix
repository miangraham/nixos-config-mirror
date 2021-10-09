{ ... }:
let
  pkgs = import ../common/stable.nix {};
  fonts = import ./fonts.nix {inherit pkgs;};
  packages = import ./packages.nix {};
  overlays = import ../common/overlays-stable.nix {};
  services = import ./services.nix {};
in
{
  imports = [
    ./network.nix
    ./sway.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # pulseaudio = true;
    };
    inherit overlays;
  };

  fonts.fonts = fonts;

  environment.systemPackages = packages;
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  time.timeZone = "Asia/Tokyo";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.coredump.enable = true;

  nix.allowedUsers = ["@wheel"];
  nix.trustedUsers = ["@wheel"];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  users.users.ian = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video" "nginx"];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };

  security.rtkit.enable = true;
  inherit services;
}
