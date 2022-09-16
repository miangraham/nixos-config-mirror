{ pkgs, lib, stdenv, fetchFromSourcehut, openssl, pkg-config, curl, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "twitch-chat-tui";
  version = "unstable-2022-09-16";

  src = fetchFromSourcehut {
    owner = "~mian";
    repo = pname;
    rev = "a97290976c4a98cd92f85b5150c6940f41e74f82";
    sha256 = "sha256-gabNM1nNFOveMmaL8crYUOcgaIZ74880wYO89ql6lDE=";
  };

  cargoSha256 = "sha256-Lw9VY3BORIrfE5gZDXUGqjpAQB4aKzWcW+DMAIGFky0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}
