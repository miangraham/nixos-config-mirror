{ pkgs, lib, config, ... }:
with lib;
{
  options.my.home-network-only = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable settings exclusive to the home network.";
    };
  };

  config = mkIf config.my.home-network-only.enable {
    networking = {
      useNetworkd = true;
      useDHCP = false;
      firewall = {
        allowedTCPPorts = [ 22 53 ];
        allowedUDPPorts = [ 53 ];
      };
    };

    services = {
      blocky = import ./blocky.nix { inherit pkgs; };
      resolved.extraConfig = "DNSStubListener=no";
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
  };
}
