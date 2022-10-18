{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-remote";
  version = "unstable-2022-10-18";

  src = fetchFromSourcehut {
    owner = "~mian";
    repo = pname;
    rev = "5d84606ecba585a91f40c72e1585693534ca1a59";
    sha256 = "sha256-UVaZmIWnRcHiveG2WLWSBlq6Hbxes7nIMDRkFKsCDuM=";
  };

  cargoSha256 = "sha256-ypUu4q32BTZPK1T9+GMDZCAs0n0qvUxmnCq/nkGeLvo=";

  doCheck = false; # No tests
}
