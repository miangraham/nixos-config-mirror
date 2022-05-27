{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-21.11"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    unstable-small = { url = "github:NixOS/nixpkgs/nixos-unstable-small"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = { url = "github:nix-community/home-manager/release-21.11"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay?rev=dddc29038a06a29b92d07cb21490b228329ae9ac"; };
    tdlib = { url = "github:tdlib/td"; flake = false; };
    ffmpeg-patch = { url = "github:yt-dlp/FFmpeg-Builds?rev=d1b456152d2618cf9266ec5ca84ed8b110acb423"; flake = false; };
    filter-tweets = { url = "path:/home/ian/filter-tweets"; flake = false; };
    otf2bdf = { url = "github:thefloweringash/kevin-nix"; flake = false; };
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
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            inputs.home-manager.nixosModules.home-manager
            { inherit home-manager; }
          ];
        };
        pika = inputs.unstable-small.lib.nixosSystem {
          inherit specialArgs;
          system = "aarch64-linux";
          modules = [
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ./box/pika/default.nix
          ];
        };
      };
    };
}
