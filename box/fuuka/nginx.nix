{ pkgs, ... }:
let
in
{
  enable = true;
  user = "nginx";
  virtualHosts = {
    fuuka = {
      serverName = "192.168.0.127";
      root = "/var/www";
      default = true;
    };
    "graham.tokyo" = {
      serverName = "graham.tokyo";
      root = "/var/www";
    };
  };
}
