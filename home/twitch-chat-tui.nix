{ pkgs, lib, stdenv, fetchFromGitHub, openssl, pkg-config, curl, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "twitch-chat-tui";
  version = "unstable-2022-09-15";

  src = fetchFromGitHub {
    owner = "stuck-overflow";
    repo = pname;
    rev = "ab62af7a58df5e6dd13e8d6ad019a97ff5f68126";
    sha256 = "sha256-uOdMB8Dp/4XI5EzbPpxiFiQmHFVAtFxusCrHqwBC03M=";
  };

  cargoSha256 = "sha256-Bo+BINKYINJVk+k8MAMx+db9+WDLyrMz0luvQFlcnEU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}
