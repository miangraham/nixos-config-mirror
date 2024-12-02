{ pkgs, config, inputs, ... }:
let
  alacritty = import ../../home/alacritty.nix { inherit pkgs; };
  firefox = import ../../home/firefox.nix { inherit pkgs; };
  kitty = import ../../home/kitty.nix { inherit pkgs; };
  mpv = import ../../home/mpv.nix { inherit pkgs; };
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs) maliit-keyboard;
    emacs = inputs.emacspkg.packages.${pkgs.system}.default;
  };

  programs = {
    inherit alacritty firefox kitty mpv;

    feh.enable = true;

    chromium = {
      enable = true;
      package = pkgs.vivaldi;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # UBO
        { id = "jeoacafpbcihiomhlakheieifhpjdfeo"; } # Disconnect
        { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentralize
        { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsorblock
      ];
    };

    plasma = {
      enable = true;
      workspace.lookAndFeel = "org.kde.breezedark.desktop";
      panels = [{
        location = "left";
      }];
      configFile = {
        "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
        "plasma-localerc"."Formats"."LC_MEASUREMENT" = "en_SE.UTF-8";
        "plasma-localerc"."Formats"."LC_PAPER" = "en_SE.UTF-8";
        "plasma-localerc"."Formats"."LC_TELEPHONE" = "en_SE.UTF-8";
        "plasma-localerc"."Formats"."LC_TIME" = "en_SE.UTF-8";

        "kcminputrc"."Libinput/4120/4102/HID 1018:1006 Touchpad"."NaturalScroll" = true;
        "kxkbrc"."Layout"."Options" = "caps:ctrl_modifier";
      };
    };
  };
}
