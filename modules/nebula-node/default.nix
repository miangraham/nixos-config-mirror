{ pkgs, lib, inputs, config, ... }:
with lib;
{
  options.my.nebula-node = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to run a nebula node.";
    };
  };

  config = mkIf config.my.nebula-node.enable {
    services.nebula.networks.asgard = {
      enable = true;
      ca = ./nebula-ca.crt;
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      lighthouses = [ "10.10.10.128" ];
      relays = [ "10.10.10.128" ];
      staticHostMap = {
        "10.10.10.128" = [
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
  };
}
