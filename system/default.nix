{ pkgs, inputs, config, ... }:
let
  fonts = import ./fonts.nix { inherit pkgs; };
  nix = import ../common/nix-settings.nix { inherit pkgs; };
  packages = import ./packages.nix { inherit pkgs inputs; };
  overlays = import ../common/overlays-stable.nix { inherit inputs pkgs; };
  services = import ./services.nix { inherit pkgs; };
  sshAuthKeys = import ../common/ssh-auth-keys.nix {};
in
{
  imports = [
    ./network.nix
  ];

  inherit fonts nix services;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    inherit overlays;
  };

  boot = {
    # 6.6 LTS
    kernelPackages = pkgs.linuxPackages_6_6;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  systemd = {
    coredump.enable = true; # false
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
    openssh.authorizedKeys.keys = sshAuthKeys;
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

  programs = {
    dconf.enable = true;
    zsh.enable = true;

    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        safe.directory = "/home/ian/.nix";
      };
    };

    nano = {
      nanorc = ''
        set nowrap
        set tabstospaces
        set tabsize 2
      '';
    };
  };
}
