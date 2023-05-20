{ config, pkgs, inputs, lib, modulesPath, ... }:
let
  inherit (builtins) concatStringsSep sort stringLength;
  unshuffle = sort (a: b: (stringLength a) < (stringLength b));
  obfuscatedIanAddr = [ "in.net" "an" "@ij" "i" ];
  ianAddr = concatStringsSep "" (unshuffle obfuscatedIanAddr);
  obfuscatedRanniAddr = [ "in.net" "r" "ni@ij" "an" ];
  ranniAddr = concatStringsSep "" (unshuffle obfuscatedRanniAddr);
in
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./monitoring.nix
    ./network.nix
    ./services.nix
    ./storage.nix
  ];

  users = {
    users.timemachine = {
      description = "Time Machine backups";
      group = "timemachine";
      isSystemUser = true;
    };
    groups.timemachine = {};

    users.borg = {
      description = "Borg backups";
      group = "borg";
      isNormalUser = true;
      home = "/srv/borg";
      openssh.authorizedKeys.keys = config.users.users.ian.openssh.authorizedKeys.keys;
    };
    groups.borg = {};

    users.dupe = {
      description = "Duplicati backups";
      group = "dupe";
      isNormalUser = true;
      home = "/srv/duplicati";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/yWOew9ozqQB39DDlTVRbLkZEQyuQTJXV5sAc4SUP9 ian@megumin"
      ];
    };
    groups.dupe = {};

  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 1025;
      # tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls_trust_file = "/home/ian/.nix/home/pmbridge_cert.pem";
      tls = "on";
      auth = "login";
      # auth = "on";
      tls_starttls = "on";
      tls_certcheck = "off"; # XXX
    };
    accounts = {
      default = {
        host = "localhost";
        passwordeval = "cat /home/ian/.ssh/pmbridge_pass";
        user = ianAddr;
        from = ranniAddr;
      };
    };
  };

  # TODO: Make these a mixin component instead of turning off here
  security.rtkit.enable = pkgs.lib.mkForce false;
  home-manager.users.ian.services.playerctld.enable = pkgs.lib.mkForce false;

  system.stateVersion = "22.11";
}
