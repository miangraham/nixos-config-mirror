{ pkgs, ... }:
let
in {
  enable = true;
  settings = {
    ports.dns = 53;
    log.timestamp = false;
    queryLog = {
      # change type to "console" to print queries to service log
      type = "none";
      fields = [ "clientIP" "responseReason" "responseAnswer" "question" "duration" ];
    };
    caching = {
      minTime = "60m";
      cacheTimeNegative = "5m";
    };
    bootstrapDns = [{
      upstream = "tcp-tls:dns.quad9.net";
      ips = [ "9.9.9.9" "149.112.112.112" ];
    } {
      upstream = "tcp-tls:dns.adguard-dns.com";
      ips = [ "94.140.14.14" "94.140.15.15" ];
    }];
    upstreams = {
      groups.default = [
        "tcp-tls:dns.quad9.net"
        "tcp-tls:dns.adguard-dns.com"
        "tcp-tls:base.dns.mullvad.net"
        "tcp-tls:p2.freedns.controld.com"
      ];
      init.strategy = "fast";
    };
    hostsFile = {
      filterLoopback = true;
      sources = [ "/etc/hosts" ];
    };
    blocking = {
      loading.refreshPeriod = "24h";
      clientGroupsBlock.default = [ "default" ];
      allowlists.default = [
        (builtins.readFile ./blocky_whitelist.txt)
      ];
      denylists.default = [
        (builtins.readFile ./blocky_blacklist.txt)
        "https://adaway.org/hosts.txt"
        "https://big.oisd.nl/domainswild"
        "https://perflyst.github.io/PiHoleBlocklist/android-tracking.txt"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        "https://v.firebog.net/hosts/AdguardDNS.txt"
      ];
    };
    conditional = {
      # applies to all subdomains
      mapping = {
        # code
        "github.com" = "192.168.0.1";
        "github.io" = "192.168.0.1";
        "nixos.org" = "192.168.0.1";

        # vid
        "googlevideo.com" = "192.168.0.1";
        "youtube.com" = "192.168.0.1";
        "ytimg.com" = "192.168.0.1";

        # social
        "discord.com" = "192.168.0.1";
        "click.discord.com" = "192.168.0.1";
      };
    };
  };
}
