{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
  ];
  system.stateVersion = "20.03";
  networking.hostName = "nene";
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  boot.kernel.sysctl = {
    "fs.file-max" = 9000000;
    # "fs.inotify.max_user_instances" = 4096;
    # "net.ipv4.tcp_fin_timeout" = 10;
  };

  # box specific due to ACME, rip
  services.nginx = {
    enable = false;
    user = "nginx";
    virtualHosts."testlocal.ian.tokyo" = {
      root = "/var/www";
      addSSL = true;
      enableACME = true;
    };
  };
  security.acme = {
    email = "spamisevil@ijin.net";
    acceptTerms = true;
  };

  services.znc = {
    enable = true;
    confOptions = {
      passBlock = "";
    };
    # extraFlags = [ "--debug" ];
  };
}
