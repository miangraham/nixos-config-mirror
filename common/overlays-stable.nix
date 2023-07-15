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
in
[
  tdOverlay
  inputs.emacs-overlay.overlay
  freshOverlay
]
