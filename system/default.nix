{ pkgs, inputs, config, ... }:
let
  fonts = import ./fonts.nix { inherit pkgs; };
  packages = import ./packages.nix { inherit pkgs inputs; };
  overlays = import ../common/overlays-stable.nix { inherit inputs pkgs; };
  services = import ./services.nix { inherit pkgs; };
in
{
  imports = [
    ./base.nix
    ./network.nix
  ];

  inherit fonts services;

  nixpkgs = { inherit overlays; };

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
      grub.enable = false;
    };
  };

  systemd.coredump.enable = true; # false

  users.users.ian = {
    shell = pkgs.zsh;
  };

  users.groups = {
    nginx.gid = config.ids.gids.nginx;
    znc.gid = config.ids.gids.znc;
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
    zsh.enable = true;
  };
}
