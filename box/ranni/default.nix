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
    ../../system/nebula-node.nix
    ./monitoring.nix
    ./network.nix
    ./services.nix
    ./storage.nix
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;
    # TODO: test removal
    kernelModules = [ "coretemp" "nct6775" ];
    # extraModprobeConfig = ''
    #   options zfs zfs_dmu_offset_next_sync=0
    # '';
  };

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

  system.stateVersion = "23.05";
}
