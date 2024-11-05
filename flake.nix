{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
      url = "github:diamondburned/nix-search?rev=e616ac1c82a616fa6e6d8c94839c5052eb8c808d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      boxConfig = system: addModules: let
        specialArgs = { inherit inputs; };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs system; };
          sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
          users.ian = import ./home {};
        };
      in (inputs.nixpkgs.lib.nixosSystem) {
        inherit specialArgs system;
        modules = addModules ++ [
          ./system/dicod/default.nix
          inputs.home-manager.nixosModules.home-manager
          { inherit home-manager; }
        ];
      };
    in {
      nixosConfigurations = {
        nene = boxConfig "x86_64-linux" [ ./box/nene ];
        anzu = boxConfig "x86_64-linux" [ ./box/anzu ];
        ema = boxConfig "x86_64-linux" [
          ./box/ema
          inputs.nixos-hardware.nixosModules.starlabs-starlite-i5
        ];
        futaba = boxConfig "x86_64-linux" [ ./box/futaba ];
        fuuka = boxConfig "x86_64-linux" [ ./box/fuuka ];
        makoto = boxConfig "x86_64-linux" [ ./box/makoto ];
        ranni = boxConfig "x86_64-linux" [ ./box/ranni ];
        rin = boxConfig "x86_64-linux" [
          ./box/rin
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        ];

        nano = boxConfig "aarch64-linux" [ ./box/nano ];

        mika = boxConfig "aarch64-linux" [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./box/mika
        ];
        pika = boxConfig "aarch64-linux" [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./box/pika
        ];
        rika = boxConfig "aarch64-linux" [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./box/rika
        ];
      };
    };
}
