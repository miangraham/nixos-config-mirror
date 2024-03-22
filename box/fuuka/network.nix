{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "fuuka";
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 7575 8008 8384 ];
      allowedUDPPorts = [ 53 8008 ];
    };
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 20;
      ignoredInterfaces = [ "docker0" ];
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
  services.syncthing.guiAddress = "0.0.0.0:8384";
}
