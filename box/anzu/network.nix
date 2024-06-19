{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "anzu";
    firewall = {
      allowedTCPPorts = [ 22 8384 8099 ];
      allowedUDPPorts = [ ];
    };
    useNetworkd = true;
    useDHCP = false;
  };
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      timeout = 20;
    };
    networks."40-wired" = {
      name = "en*";
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
