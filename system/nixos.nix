{ pkgs, inputs, ... }:
let
  unstable = import ../common/unstable.nix {inherit pkgs inputs;};
  fonts = import ./fonts.nix {inherit pkgs;};
  packages = import ./packages.nix {inherit pkgs inputs;};
  overlays = import ../common/overlays-stable.nix {inherit inputs pkgs;};
  services = import ./services.nix {inherit pkgs;};
in
{
  imports = [
    ./network.nix
    ./sway.nix
  ];

  inherit fonts services;

  time.timeZone = "Asia/Tokyo";
  systemd.coredump.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    inherit overlays;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    package = unstable.nix_2_4;
    allowedUsers = ["@wheel" "nix-ssh"];
    trustedUsers = ["@wheel"];
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ="
    ];
  };

  users.users.ian = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "dialout"
      "networkmanager"
      "nginx"
      "video"
      "wheel"
    ];
  };

  environment = {
    systemPackages = packages;
    pathsToLink = [
      "/share/nix-direnv"
    ];
  };

  security = {
    rtkit.enable = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=20
    '';
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };
}
