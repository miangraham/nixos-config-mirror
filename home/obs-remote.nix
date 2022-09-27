{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-remote";
  version = "unstable-2022-09-28";

  src = fetchFromSourcehut {
    owner = "~mian";
    repo = pname;
    rev = "517b77dfc350ba33a651e41f0ce8b647c342ed29";
    sha256 = "sha256-6MrHHyS6R+r4eMjSORdYOnFdbbXd0kVgCZFyC900TpE=";
  };

  cargoSha256 = "sha256-RHdyfZFRDdcfsnzuAYIW9g7cdPv6adbmtLEgC08EE70=";

  doCheck = false; # No tests
}
