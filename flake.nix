{
  description = "";
  inputs = {
    nixpkgs = { url = "https://releases.nixos.org/nixos/21.05/nixos-21.05.3990.372e59d2af7/nixexprs.tar.xz"; };
    unstable = { url = "https://releases.nixos.org/nixos/unstable/nixos-21.11pre327669.b67e752c29f/nixexprs.tar.xz"; };
    emacs-overlay = { url = "https://github.com/nix-community/emacs-overlay/archive/de536fa76c469b25e377674028641f6fe03b602d.tar.gz"; };
    tdlib = { url = "https://github.com/tdlib/td/archive/49282f35a5eb6a53a6005a8a7d3cbb2fd99c992b.tar.gz"; flake = false; };
    home-manager = { url = "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz"; };
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
