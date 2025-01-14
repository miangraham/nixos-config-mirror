{ pkgs, inputs, config, ... }:
let
  packages = import ./packages.nix { inherit pkgs inputs; };
  overlays = import ../../common/overlays-stable.nix { inherit inputs pkgs; };
  services = import ./services.nix { inherit pkgs; };
  networking = import ./networking.nix { inherit pkgs; };
in
{
  inherit networking services;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  nix = import ./nix-settings.nix { inherit pkgs; };
  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  systemd.coredump.enable = true; # false

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

    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        safe.directory = "/home/ian/.nix";
      };
    };

    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';
  };
}
