{ ... }:
let
in
{
  stable = fetchTarball {
    url = "https://releases.nixos.org/nixos/21.05/nixos-21.05.3990.372e59d2af7/nixexprs.tar.xz";
    sha256 = "1hh8yig9nhky3p3grxky62a809hrzy2n4jxffw7pyridghwxpfbr";
  };
  unstable = fetchTarball {
    url = "https://releases.nixos.org/nixos/unstable/nixos-21.11pre327669.b67e752c29f/nixexprs.tar.xz";
    sha256 = "15h2d5s6lqxyrmqd6ghbkizqr0ml3qjrwasmapj07m6cpkwpxc7i";
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
