{ pkgs, inputs, ... }:
let
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
            version = "custom-mian";
            patches = [ ./invidious-customization.patch ];
          });
      };
    };
  });
in
[
  freshOverlay
  invidOverlay
]
