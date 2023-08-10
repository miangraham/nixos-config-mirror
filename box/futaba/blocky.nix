{ pkgs, ... }:
let
in {
  enable = true;
  settings = {
    port = 53;
    upstream.default = [
      "tcp-tls:dns.quad9.net"
      "tcp-tls:dns.adguard-dns.com"
      "tcp-tls:doh.mullvad.net"
      "tcp-tls:p2.freedns.controld.com"
    ];
    caching = {
      minTime = "10m";
      cacheTimeNegative = "1m";
    };
    blocking = {
      blackLists.default = [
        (builtins.readFile ./blocky_blacklist.txt)
        "https://big.oisd.nl/domains"
        "https://adaway.org/hosts.txt"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://perflyst.github.io/PiHoleBlocklist/android-tracking.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
      ];
      whiteLists.default = [];
      clientGroupsBlock.default = [ "default" ];
    };
    conditional = {
      # applies to all subdomains
      mapping = {
        # code
        "fastly.net" = "192.168.0.1";
        "github.com" = "192.168.0.1";
        "github.io" = "192.168.0.1";
        "nixos.org" = "192.168.0.1";

        # vid
        "googlevideo.com" = "192.168.0.1";
        "youtube.com" = "192.168.0.1";
        "ytimg.com" = "192.168.0.1";
      };
    };
  };
}
