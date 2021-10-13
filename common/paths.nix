{ ... }:
let
in
{
  stable = fetchTarball {
    url = "https://releases.nixos.org/nixos/21.05/nixos-21.05.3740.ce7a1190a0f/nixexprs.tar.xz";
    sha256 = "112drvixj81vscj8cncmks311rk2ik5gydpd03d3r0yc939zjskg";
  };
  unstable = fetchTarball {
    url = "https://releases.nixos.org/nixos/unstable/nixos-21.11pre322215.9bf75dd50b7/nixexprs.tar.xz";
    sha256 = "04bvfkr28xks9qqpn3fixcn8rdlyjhnqnbrg4ynwzqick0j3zcgw";
  };
  emacs-overlay = fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/1fbdcc136511834878b122a34b6fdb2af5302ddd.tar.gz";
    sha256 = "03hxkrljm6vdrw903f9rb1biq20886fybxwhm8c7pv0hm6h031dz";
  };
}
