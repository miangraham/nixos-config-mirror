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
      url = "https://codeberg.org/mian/emacs-config/archive/master.tar.gz";
      # url = "git+file:/home/ian/.emacs.d?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      emacs = inputs.emacspkg.packages.${system}.default;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.ian = import ./home {inherit inputs system;};
      };
      boxConfig = addModules: (inputs.nixpkgs.lib.nixosSystem) {
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
        nene = boxConfig [
          ./box/nene
        ];
        fuuka = boxConfig [
          ./box/fuuka
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
        pika = inputs.nixpkgs.lib.nixosSystem {
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
