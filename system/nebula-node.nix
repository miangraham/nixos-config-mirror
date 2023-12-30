{ pkgs, inputs, config, ... }:
let
in
{
  services.nebula.networks.asgard = {
    enable = false;
    ca = "/etc/nebula/ca.crt";
    cert = "/etc/nebula/host.crt";
    key = "/etc/nebula/host.key";
    lighthouses = [ "192.168.100.128" ];
    relays = [ "192.168.100.128" ];
    staticHostMap = {
      "192.168.100.128" = [
        "192.168.0.128:4242"
        "122.249.92.87:4242"
      ];
    };
    firewall = {
      inbound = [
        { port = "any"; proto = "icmp"; host = "any"; }
        { port = 22; proto = "tcp"; host = "any"; }
        { port = 8384; proto = "tcp"; host = "any"; } # syncthing
      ];
      outbound =  [ { port = "any"; proto = "any"; host = "any"; } ];
    };
    settings.preferred_ranges = [ "192.168.0.0/24" ];
  };
}
