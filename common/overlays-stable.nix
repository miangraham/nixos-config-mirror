{ pkgs, inputs, ... }:
let
  invidOverlay = (self: super: {
    invidious = super.callPackage "${inputs.nixpkgs}/pkgs/by-name/in/invidious/package.nix" {
      crystal = super.crystal // {
        buildCrystalPackage = args:
          super.crystal.buildCrystalPackage (args // {
            version = "custom-mian";
            patches = [ ./invidious-customization.patch ];
          });
      };
    };
  });
in
[
  invidOverlay
]
