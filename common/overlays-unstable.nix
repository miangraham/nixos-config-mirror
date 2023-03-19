{ pkgs, inputs, ... }:
let
  inherit (pkgs) system;
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });
  invidOverlay = (self: super: {
    invidious = super.callPackage "${inputs.unstable}/pkgs/servers/invidious" {
      crystal = super.crystal // {
        buildCrystalPackage = args:
          super.crystal.buildCrystalPackage (args // {
            version = "custom-mian-unstable";
            patches = [ ./invidious-customization.patch ];
            src = inputs.invidious;
          });
      };
      lsquic = super.callPackage "${inputs.unstable}/pkgs/servers/invidious/lsquic.nix" { };
      videojs = super.callPackage "${inputs.unstable}/pkgs/servers/invidious/videojs.nix" { };
    };
  });
in
[
  tdOverlay
  invidOverlay
]
