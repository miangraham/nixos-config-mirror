{ ... }:
let
  pkgs = import ../common/stable.nix {};
  fonts = import ./fonts.nix {inherit pkgs;};
  packages = import ./packages.nix {};
  overlays = import ../common/overlays-stable.nix {};
  services = import ./services.nix {};

  nixpkgsPathCfg = (import ../common/paths.nix {}).stable;
in
{
  imports = [
    ./network.nix
    ./sway.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
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
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.coredump.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    nixPath = [
      # NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
      # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      # "nixpkgs=${fetchTarball (builtins.readFile ../nix/stable_nixpkgs_tarball_url)}"
      "nixpkgs=${nixpkgsPathCfg}"
      "nixos-config=/home/ian/.nix/configuration.nix"
      # "/nix/var/nix/profiles/per-user/root/channels"
    ];
    allowedUsers = ["@wheel"];
    trustedUsers = ["@wheel"];
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # sshServe.enable = true;
    # sshServe.keys = [ "ssh-dss AAAAB3NzaC1k... bob@example.org" ];
  };

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

  security = {
    rtkit.enable = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=20
    '';
  };
  inherit services;
}
