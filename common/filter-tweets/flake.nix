{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/release-22.05"; };
  };
  outputs = {self, nixpkgs}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      defaultPackage.${system} = pkgs.hello;
    };
}
