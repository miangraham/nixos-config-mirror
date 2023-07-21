{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-23.05"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-23.05"; };
    small = { url = "github:NixOS/nixpkgs/nixos-23.05-small"; };

    home-manager = { url = "github:nix-community/home-manager/release-23.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };

    tdlib = { url = "github:tdlib/td?rev=c95598e5e1493881d31211c1329bdbe4630f6136"; flake = false; };
  };
  outputs = inputs:
    let
      specialArgs = { inherit inputs; };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.ian = import ./home {inherit inputs; system = "x86_64-linux";};
      };
      boxConfig = addModules: (inputs.nixpkgs.lib.nixosSystem) {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = addModules ++ [
          ./system/dicod/default.nix
          inputs.home-manager.nixosModules.home-manager
          { inherit home-manager; }
        ];
      };
    in {
      nixosConfigurations = {
        nene = boxConfig [
          ./box/nene
        ];
        futaba = boxConfig [
          ./box/futaba
        ];
        ranni = boxConfig [
          ./box/ranni
        ];
        rin = boxConfig [
          ./box/rin
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        ];
        pika = inputs.small.lib.nixosSystem {
          inherit specialArgs;
          system = "aarch64-linux";
          modules = [
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ./box/pika
          ];
        };
      };
    };
}
