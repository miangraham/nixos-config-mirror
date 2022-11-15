{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-22.05"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    unstable-small = { url = "github:NixOS/nixpkgs/nixos-unstable-small"; };
    # dev = { url = "github:NixOS/nixpkgs/master"; };
    invid-testing = { url = "github:geopjr-forks/nixpkgs/update/crystal"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = { url = "github:nix-community/home-manager/release-22.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };

    hyprland = { url = "github:hyprwm/Hyprland/v0.17.0beta"; inputs.nixpkgs.follows = "unstable"; };
    hyprpaper = { url = "github:hyprwm/hyprpaper"; inputs.nixpkgs.follows = "unstable"; };

    tdlib = { url = "github:tdlib/td?rev=92f8093486f19c049de5446cc20950e641c6ade0"; flake = false; };
    ffmpeg-patch = { url = "github:yt-dlp/FFmpeg-Builds?rev=d1b456152d2618cf9266ec5ca84ed8b110acb423"; flake = false; };
    eww = { url = "github:elkowar/eww"; inputs.nixpkgs.follows = "unstable"; };

    moby = { url = "sourcehut:~mian/dico-moby-prototype"; };
    twitch-alerts = { url = "sourcehut:~mian/twitch-alerts"; inputs.nixpkgs.follows = "nixpkgs"; };
    # moby = { url = "path:/home/ian/moby"; };
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
          inputs.hyprland.nixosModules.default
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
        rin = boxConfig [
          ./box/rin
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        ];
        pika = inputs.unstable-small.lib.nixosSystem {
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
