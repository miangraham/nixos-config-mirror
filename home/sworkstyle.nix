{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "swayest_workstyle";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = pname;
    rev = "9bf5b3e5998d1b21b0ad49eece26b388be7960ef";
    sha256 = "sha256-PG7+WIKTY2YqxL7MniZWNmWGh7+5it6VNO69CF49G1Q=";
  };

  cargoSha256 = "sha256-ouNJQN/Gt0pN1eF+PhhulNaUzM0iaCmRLFqyMn09dH8=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "(sway) Map workspace name to icons defined depending on the windows inside of the workspace.";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ miangraham ];
  };
}
