{
  description = "";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-22.11"; };
    unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    small = { url = "github:NixOS/nixpkgs/nixos-22.11-small"; };
    # invid-testing = { url = "github:miangraham/nixpkgs/invid-tweaks-6"; };

    home-manager = { url = "github:nix-community/home-manager/release-22.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };

    eww = { url = "github:elkowar/eww"; inputs.nixpkgs.follows = "nixpkgs"; };
    # hyprland = { url = "github:hyprwm/Hyprland/v0.18.0beta"; inputs.nixpkgs.follows = "nixpkgs"; };
    # hyprpaper = { url = "github:hyprwm/hyprpaper?rev=ab85578dce442b80aa3378fe0304e6cb6f16f593"; inputs.nixpkgs.follows = "nixpkgs"; };

    tdlib = { url = "github:tdlib/td?rev=1543c41f3411bd6aa74713c8aba4e93fa8d952c7"; flake = false; };
    ffmpeg-patch = { url = "github:yt-dlp/FFmpeg-Builds?rev=d1b456152d2618cf9266ec5ca84ed8b110acb423"; flake = false; };

    moby = { url = "sourcehut:~mian/dico-moby-prototype"; };
    twitch-alerts = { url = "sourcehut:~mian/twitch-alerts"; inputs.nixpkgs.follows = "nixpkgs"; };
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
          # inputs.hyprland.nixosModules.default
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
