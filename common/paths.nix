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
    url = "https://github.com/nix-community/emacs-overlay/archive/de536fa76c469b25e377674028641f6fe03b602d.tar.gz";
    sha256 = "1hj5qv915fklgmn60b8csa368s3h6vz6m7z6ws1arbgnzchw5pp3";
  };
  tdlib = {
    version = "unstable-2021-10-15";
    src = fetchTarball {
      url = "https://github.com/tdlib/td/archive/49282f35a5eb6a53a6005a8a7d3cbb2fd99c992b.tar.gz";
      sha256 = "1ml20smdivvh078sdb7fxh3inqqkbjicd0hxfpw8sd5vs5fv4ddv";
    };
  };
}
