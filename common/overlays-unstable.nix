{ pkgs, inputs, ... }:
let
  inherit (pkgs) system;
  invidOverlay = (self: super: {
    invidious = super.callPackage "${inputs.unstable}/pkgs/servers/invidious" {
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
