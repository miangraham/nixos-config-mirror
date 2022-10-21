{ pkgs, lib, stdenv, fetchFromSourcehut, openssl, pkg-config, curl, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "twitch-chat-tui";
  version = "unstable-2022-09-16";

  src = fetchFromSourcehut {
    owner = "~mian";
    repo = pname;
    rev = "fc780a2d073d6480568ecf5e40bae0e0e594d394";
    sha256 = "sha256-0olgH/VzgS+LDZBqJN7ONI3zPg90bxqSohW8Ww40Erc=";
  };

  cargoSha256 = "sha256-Lw9VY3BORIrfE5gZDXUGqjpAQB4aKzWcW+DMAIGFky0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}
