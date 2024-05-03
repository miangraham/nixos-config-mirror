{ config, lib, inputs, pkgs, ... }:
{
  networking = {
    hostName = "nano";
    firewall = {
      allowedTCPPorts = [ 22 53 80 443 8384 ];
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
      ignoredInterfaces = [ "docker0" ];
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
  services.syncthing.guiAddress = "0.0.0.0:8384";
}
