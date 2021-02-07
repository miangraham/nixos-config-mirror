{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;
  fonts = import ./fonts.nix {inherit pkgs;};
  packages = import ./packages.nix {};
  overlays = import ../common/overlays.nix {};
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
      pulseaudio = true;
    };
    inherit overlays;
  };

  fonts.fonts = fonts;
  # fonts.fontconfig.disableVersionedFontConfiguration = true;

  environment.systemPackages = packages;
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  time.timeZone = "Asia/Tokyo";

  boot.kernelPackages = unstable.linuxPackages_latest;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 100;
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

  users.users.nginx = {
    isNormalUser = true;
    extraGroups = ["nginx"];
  };

  hardware.pulseaudio.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # extraLocaleSettings = {
    #   LC_CTYPE = "ja_JP.UTF-8";
    # };
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 1935 3478 8443 ];
  inherit services;
}
