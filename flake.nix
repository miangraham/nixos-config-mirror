{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-21.05"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    home-manager = { url = "github:nix-community/home-manager/release-21.05"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; };
    tdlib = { url = "github:tdlib/td"; flake = false; };
    filter-tweets = { url = "path:/home/ian/filter-tweets"; flake = false; };
  };
  outputs = inputs:
    let
      specialArgs = { inherit inputs; };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.ian = import ./home/default.nix {inherit inputs;};
      };
    in {
      nixosConfigurations = {
        nene = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./box/nene/default.nix
            inputs.home-manager.nixosModules.home-manager
            { inherit home-manager; }
          ];
        };
        futaba = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./box/futaba/default.nix
            inputs.home-manager.nixosModules.home-manager
            { inherit home-manager; }
          ];
        };
        rin = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./box/rin/default.nix
            inputs.home-manager.nixosModules.home-manager
            { inherit home-manager; }
          ];
        };
      };
    };
}
