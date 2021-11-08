{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/release-21.05"; };
    unstable = { url = "github:NixOS/nixpkgs"; };
    emacs-overlay = { url = "https://github.com/nix-community/emacs-overlay/archive/de536fa76c469b25e377674028641f6fe03b602d.tar.gz"; };
    tdlib = { url = "https://github.com/tdlib/td/archive/49282f35a5eb6a53a6005a8a7d3cbb2fd99c992b.tar.gz"; flake = false; };
    home-manager = { url = "github:nix-community/home-manager/release-21.05"; };
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ian = import ./home/default.nix {inherit inputs;};
          }
        ];
      };
    };
  };
}
