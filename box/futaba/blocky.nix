{ pkgs, ... }:
let
in {
  enable = true;
  settings = {
    port = 53;
    upstream = {
      default = [
        "tcp-tls:dns.quad9.net"
        "tcp-tls:dns.adguard-dns.com"
      ];
    };
    # caching = {
    #   minTime = "5m";
    #   cacheTimeNegative = "1m";
    # };
    blocking = {
      blackLists.default = [
        "https://big.oisd.nl/domains"
        "https://adaway.org/hosts.txt"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://perflyst.github.io/PiHoleBlocklist/android-tracking.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
      ];
      whiteLists.default = [
        "*.googlevideo.com"
        "*.youtube.com"
      ];
    };
    conditional = {
      mapping = {
        "googlevideo.com" = "192.168.0.1";
        "*.googlevideo.com" = "192.168.0.1";
        "youtube.com" = "192.168.0.1";
        "*.youtube.com" = "192.168.0.1";
      };
    };
  };
}
