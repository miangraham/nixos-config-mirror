{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "nene";
    firewall.allowedTCPPorts = [ 22 80 443 5672 8443 8080 41641 ];
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks."40-wired" = {
      name = "en*";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        DHCP = "yes";
        # DNSSEC = "yes";
        # DNSOverTLS = "yes";
        # DNS = [ "1.1.1.1" "1.0.0.1" ];
      };
    };
  };
}
