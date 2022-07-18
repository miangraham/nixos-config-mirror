{ pkgs, lib, stdenv, fetchFromGitHub, openssl, pkg-config, curl, rustPlatform }:
let
  # rust = pkgs.rust-bin.stable.latest.default;
  # rustPlatform = pkgs.makeRustPlatform {
  #   cargo = rust;
  #   rustc = rust;
  # };
in
rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "v2.0.0-alpha6";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "8d9f748799dfe96239f614d09492eb9fa31dce36";
    sha256 = "sha256-V1cRPUGofJJXfvW47vAqR4bs0/JD616wzHW2L0W5GKQ=";
  };

  cargoSha256 = "sha256-ccnPli50F+l0OnOYAk0xLUk3wM28nm8JlO8dedydp8M=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}
