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
            src = pkgs.fetchFromGitHub {
              owner = "miangraham";
              repo = "invidious";
              fetchSubmodules = true;
              rev = "89adcad99f290b500d09569a53d9e3d094c2db18";
              sha256 = "sha256-0AhdTUVobepzDJXGiZsiiKJhDCUx+442t5TeN8Fqiw8=";
            };
            version = "custom-mian-2023-03-03";
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
