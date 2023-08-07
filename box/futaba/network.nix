{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "futaba";
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 1883 4533 8081 8089 8384 8443 8989 9090 41641 ];
      allowedUDPPorts = [ 53 ];
    };
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 20;
      ignoredInterfaces = [ "docker0" "tailscale0" ];
    };
    networks."40-wired" = {
      name = "en*";
      # linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        DHCP = "yes";
        DNS = [ "192.168.0.1" ];
      };
    };
  };
  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';
}
