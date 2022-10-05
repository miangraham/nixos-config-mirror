{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
  makeDictdDB = src: _name: _subdir: _locale:
    stdenv.mkDerivation {
      name = "dictd-db-${_name}";
      inherit src;
      locale = _locale;
      dbName = _name;
      buildInputs = [ pkgs.dpkg ];
      unpackPhase = ''
        dpkg -x ${src} ./
      '';
      installPhase = ''
        mkdir -p $out/share/dictd
        cp $(ls ./${_subdir}/*.{dict*,index} || true) $out/share/dictd
        echo "${_locale}" >$out/share/dictd/locale
      '';
    };
in
makeDictdDB (builtins.fetchurl {
  url = "mirror://debian/pool/main/d/dict-gcide/dict-gcide_0.48.5+nmu2_all.deb";
  sha256 = "sha256:03xc8xrnzg5y947s8dqgg71dgkimqcpgjy3fkmgfzg9wvv7za2kv";
}) "gcide" "usr/share/dictd" "en_US"
