{ ... }:
let
in
{
  stable = fetchTarball {
    url = "https://releases.nixos.org/nixos/21.05/nixos-21.05.3740.ce7a1190a0f/nixexprs.tar.xz";
    sha256 = "112drvixj81vscj8cncmks311rk2ik5gydpd03d3r0yc939zjskg";
  };
  unstable = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/9bf75dd50b7b6d3ce6aaf6563db95f41438b9bdb.tar.gz";
    sha256 = "0ii3z5v9p21la8gc8l136s5rax932awz7mk757jciai766lp2fhz";
  };
  emacs-overlay = fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/de51ad003df13d41a1107a1ed766eb226ef9382c.tar.gz";
    sha256 = "1spfd7wx7lz48kk7cs91gjx6zhvlliqc6376rxkc4idfb0q43xih";
  };
}
