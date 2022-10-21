{ lib
, stdenv
, fetchFromGitea
, guile
, autoreconfHook
, pkg-config
, texinfo
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "guile-sqlite3";
  version = "0.1.3";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "guile-sqlite3";
    repo = "guile-sqlite3";
    rev = "v${version}";
    sha256 = "sha256-C1a6lMK4O49043coh8EQkTWALrPolitig3eYf+l+HmM=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    sqlite
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  doCheck = true;
}
