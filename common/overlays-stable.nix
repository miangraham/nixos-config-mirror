{ pkgs, inputs, ... }:
let
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });
  freshOverlay = (self: super: {
    freshrss = super.freshrss.overrideAttrs(old: {
      overrideConfig = pkgs.writeText "constants.local.php" ''
        <?php
          define('DATA_PATH', getenv('FRESHRSS_DATA_PATH'));
          define('THIRDPARTY_EXTENSIONS_PATH', getenv('FRESHRSS_THIRDPARTY_EXTENSIONS_PATH'));
      '';
    });
  });
  invidOverlay = (self: super: {
    invidious = super.callPackage "${inputs.nixpkgs}/pkgs/servers/invidious" {
      crystal = super.crystal // {
        buildCrystalPackage = args:
          super.crystal.buildCrystalPackage (args // {
            version = "custom-mian-2023-03-09";
            patches = [ ./invidious-customization.patch ];
            src = inputs.invidious;
          });
      };
      lsquic = super.callPackage "${inputs.nixpkgs}/pkgs/servers/invidious/lsquic.nix" { };
      videojs = super.callPackage "${inputs.nixpkgs}/pkgs/servers/invidious/videojs.nix" { };
    };
  });
in
[
  tdOverlay
  inputs.emacs-overlay.overlay
  freshOverlay
  invidOverlay
]
