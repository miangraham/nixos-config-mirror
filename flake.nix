{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/release-21.05"; };
    unstable = { url = "github:NixOS/nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager/release-21.05"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; };
    tdlib = { url = "github:tdlib/td"; flake = false; };
    filter-tweets = { url = "path:/home/ian/filter-tweets"; flake = false; };
  };
  outputs = inputs: {
    nixosConfigurations = {
      nene = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./box/nene/default.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ian = import ./home/default.nix {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
