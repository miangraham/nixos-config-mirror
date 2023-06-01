{ pkgs, inputs, config, ... }:
let
  fonts = import ./fonts.nix { inherit pkgs; };
  packages = import ./packages.nix { inherit pkgs inputs; };
  overlays = import ../common/overlays-stable.nix { inherit inputs pkgs; };
  services = import ./services.nix { inherit pkgs; };
in
{
  imports = [
    ./hyprland.nix
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
    # 6.1 LTS
    kernelPackages = pkgs.linuxPackages_6_1;
    # kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "coretemp" "nct6775" "v4l2loopback" ];
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
      dates = "Sat *-*-* 00:00:00";
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
    suppressedSystemUnits = [
      "systemd-oomd.service"
      "systemd-oomd.socket"
    ];
  };

  users.groups = {
    nginx.gid = config.ids.gids.nginx;
    znc.gid = config.ids.gids.znc;
  };

  users.users.ian = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "dicod"
      "libvirtd"
      "networkmanager"
      "nginx"
      "video"
      "wheel"
      "znc"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcbC9h0gXGiyRCKE4Pj8jJ4loQ89QyeG7m3H2hLm6Fc ian@futaba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICD/gQKLw/+A7JQLLvX+pz7MS0g17hf3GHrzCmOaPUH1 ian@maho"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDJuEytWrkjLvzsiqisYAfdgDzk6SKf4e0u0OEqWJ9Y ian@nene"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVoASwk1Nn4Tf6DZIqS93E3k03wcoXWl4+dPGwvMMbm ian@ranni"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtZ9GKY548o3w65T0HAQjULyuKthQzenZ36LO18brZo ian@rin"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoz19hQxf246vOlfY8eIj9JqOqrxkUuAsP1jxVWQoBV/x2/gusKxLakifXTkz+Pl3cB2AtE5XBnUlixtN9xpE9mn+/6i5zBbdwJvvW2/r6eq6o+/mmGsvKcpwfTwdNQ5RWLBpDsHWNeA+r6k8Yi6X/ca6WzOGfvIh3YehdJpdpLDnd2+8cDWwGgGgPTYtXO+2yTg24htjfrsX7zn3TToVJQi+rThF1telelnhxKEZauNIrc7jLYZcUs5RTyEMyo8+onT/VMvItr2PiDdquEDWJZH9ZM+5NnDXZhrnqOUIqbbwcb66AXbELtTpql8dv/tl0K5bWMtM6aYcInln9sk2h ian@yuno"
    ];
  };

  environment = {
    systemPackages = packages;
    pathsToLink = [
      "/share/nix-direnv"
      "/share/zsh"
    ];
    shells = [
      pkgs.zsh
    ];
  };

  security = {
    rtkit.enable = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=20
    '';
    pam.loginLimits = [{
      domain = "*";
      type = "-";
      item = "nofile";
      value = "8192";
    }];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-mozc ];
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
    zsh.enable = true;

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
