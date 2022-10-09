{ pkgs, dico, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "gcide";
  version = "0.53";

  src = pkgs.fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-06y9mE3hzgItXROZA4h7NiMuQ24w7KLLD7HAWN1/MZ8=";
  };
  nativeBuildInputs = [ dico ];
  buildPhase = ''
     ${dico}/libexec/idxgcide .
  '';
  installPhase = ''
    mkdir -p $out
    cp * $out/
  '';
}
