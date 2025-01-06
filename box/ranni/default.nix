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
    ./monitoring.nix
    ./services.nix
    ./storage.nix
  ];

  my.backup.home-to-local.enable = true;
  my.backup.home-to-rnet.enable = true;
  my.home-network-only.enable = true;
  my.nebula-node.enable = true;

  networking = {
    hostName = "ranni";
    hostId = "cd1da50a";
    firewall = {
      allowedTCPPorts = [ 80 443 4533 8081 8088 8089 8384 8385 8443 8989 9090 19999 41641 ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.network.networks."40-wired".linkConfig.RequiredForOnline = "routable";

  boot = {
    # LTS, ZFS compatible. Verify ZFS before bumping.
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    # TODO: test removal
    kernelModules = [ "coretemp" "nct6775" ];
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
      openssh.authorizedKeys.keys = config.users.users.ian.openssh.authorizedKeys.keys ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpNhkzSLWVDcEQXLHuGoBKuq2bzHVbjJ6QZFmwRd5La ian@anzu"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3BTKXqv/dMXbzhG+twUtXIIAgIN89JsJng/MGKB78S ian@fuuka"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDoMfTSaoMOxxK8f9RIH+z44zreUu/2/MqASXGZ1ot0 ian@makoto"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVtjj+KAdt85pX3jLej8yno1xm58vrMVhLg1N5zV1L4 ian@pika"
      ];
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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  system.stateVersion = "23.05";
}
