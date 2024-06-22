{ pkgs, ... }:
{
  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall = {
      allowedTCPPorts = [ 22 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      ignoredInterfaces = [ "docker0" ];
      timeout = 20;
    };
    networks."40-wired" = {
      name = "en*";
      networkConfig = {
        DHCP = "yes";
        DNS = [ "127.0.0.1" ];
      };
    };
  };
  services = {
    blocky = import ../common/blocky.nix { inherit pkgs; };
    resolved.extraConfig = "DNSStubListener=no";
  };
}
