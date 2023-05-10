{ config, pkgs, inputs, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
    ./storage.nix
    ./services.nix
  ];

  networking = {
    hostName = "ranni";
    hostId = "cd1da50a";
    interfaces.enp9s0f1np0.useDHCP = true;
    interfaces.enp9s0f1np1.useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 4533 8081 8089 8384 8443 8989 9090 19999 41641 ];
      allowedUDPPorts = [ 53 ];
    };
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
        # passwordeval = "sudo -u ian PASSWORD_STORE_DIR=/home/ian/.local/share/password-store /etc/profiles/per-user/ian/bin/pass show pmbridge";
        passwordeval = "cat /home/ian/.ssh/pmbridge_pass";
        user = "ian@ijin.net";
        from = "ian@ijin.net";
      };
    };
  };

  # TODO: Make these a mixin component instead of turning off here
  security.rtkit.enable = pkgs.lib.mkForce false;
  home-manager.users.ian.services.playerctld.enable = pkgs.lib.mkForce false;

  system.stateVersion = "22.11";
}
