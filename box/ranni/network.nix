{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "ranni";
    hostId = "cd1da50a";
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 4533 8081 8089 8384 8385 8443 8989 9090 19999 41641 ];
      allowedUDPPorts = [ 53 ];
    };
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
        DNS = [ "192.168.0.1" ];
        # DNSSEC = "yes";
        # DNSOverTLS = "yes";
        # DNS = [ "1.1.1.1" "1.0.0.1" ];
      };
    };
  };
  services.nebula.networks.asgard.firewall.inbound = [
    { port = 4533; proto = "tcp"; host = "any"; } # navidrome
    { port = 8096; proto = "tcp"; host = "any"; } # jellyfin
    { port = 8989; proto = "tcp"; host = "any"; } # grafana
  ];
  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';
}
