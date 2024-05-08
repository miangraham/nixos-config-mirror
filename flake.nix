{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-23.11"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable-small"; };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacspkg = {
      url = "git+https://codeberg.org/mian/emacs-config";
      # url = "git+file:/home/ian/.emacs.d?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      boxConfig = system: addModules: let
        specialArgs = { inherit inputs; };
        emacs = inputs.emacspkg.packages.${system}.default;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.ian = import ./home {inherit inputs system;};
        };
      in (inputs.nixpkgs.lib.nixosSystem) {
        inherit specialArgs system;
        modules = addModules ++ [
          ./system/dicod/default.nix
          inputs.home-manager.nixosModules.home-manager
          { inherit home-manager; }
          { home-manager.users.ian.home.packages = [ emacs ]; }
        ];
      };
    in {
      nixosConfigurations = {
        nene = boxConfig "x86_64-linux" [ ./box/nene ];
        futaba = boxConfig "x86_64-linux" [ ./box/futaba ];
        fuuka = boxConfig "x86_64-linux" [ ./box/fuuka ];
        ranni = boxConfig "x86_64-linux" [ ./box/ranni ];
        rin = boxConfig "x86_64-linux" [
          ./box/rin
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        ];

        nano = boxConfig "aarch64-linux" [ ./box/nano ];

        pika = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ./box/pika
          ];
        };
      };
    };
}
