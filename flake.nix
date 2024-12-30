{
  description = "NixOS configuration for my personal machines.";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.11"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    emacspkg = {
      url = "git+https://codeberg.org/mian/emacs-config";
      # url = "git+file:/home/ian/.emacs.d?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixsearch = {
      url = "github:diamondburned/nix-search";
      # url = "github:diamondburned/nix-search?rev=e616ac1c82a616fa6e6d8c94839c5052eb8c808d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      baseModules = with builtins; map (n: ./modules/${n}) (attrNames (readDir ./modules));
      boxConfig = boxModule: inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = baseModules ++ [ boxModule ];
      };
    in {
      nixosConfigurations = with builtins; mapAttrs (n: _: boxConfig ./box/${n}) (readDir ./box);
      devShells = inputs.nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: {
        default = import ./util/builder-shell.nix { inherit inputs system; };
      });
    };
}
