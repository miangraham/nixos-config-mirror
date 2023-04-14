{ pkgs, inputs, config, ... }:
let
  fonts = import ./fonts.nix { inherit pkgs; };
  packages = import ./packages.nix { inherit pkgs inputs; };
  overlays = import ../common/overlays-stable.nix { inherit inputs pkgs; };
  services = import ./services.nix { inherit pkgs; };
in
{
  imports = [
    ./network.nix
    ./xdg.nix
  ];

  inherit fonts services;

  time.timeZone = "Asia/Tokyo";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    inherit overlays;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
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
    package = pkgs.nixVersions.stable;
    settings = {
      allowed-users = ["@wheel" "nix-ssh"];
      trusted-users = ["@wheel"];
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nene-1:tETUAQxI2/WCqFqS0J+32RgAqFrZXAkLtIHByUT7AjQ="
      ];
    };
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
  };

  systemd = {
    coredump.enable = true; # false
    oomd.enable = false;
  };

  users.groups = {
    znc.gid = config.ids.gids.znc;
  };

  users.users.ian = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "dicod"
      "networkmanager"
      "nginx"
      "video"
      "wheel"
      "znc"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcbC9h0gXGiyRCKE4Pj8jJ4loQ89QyeG7m3H2hLm6Fc ian@futaba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICD/gQKLw/+A7JQLLvX+pz7MS0g17hf3GHrzCmOaPUH1 ian@maho"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDJuEytWrkjLvzsiqisYAfdgDzk6SKf4e0u0OEqWJ9Y ian@nene"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtZ9GKY548o3w65T0HAQjULyuKthQzenZ36LO18brZo ian@rin"
    ];
  };

  environment = {
    systemPackages = packages;
    pathsToLink = [
      "/share/nix-direnv"
      "/share/zsh"
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

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        safe.directory = "/home/ian/.nix";
      };
    };

    adb.enable = true;
    noisetorch.enable = true;
    wshowkeys.enable = true;

    # hyprland = {
    #   enable = true;
    #   recommendedEnvironment = true;
    # };

    nano = {
      nanorc = ''
        set nowrap
        set tabstospaces
        set tabsize 2
      '';
    };
  };
}
