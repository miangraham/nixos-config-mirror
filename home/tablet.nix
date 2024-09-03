{ pkgs, config, inputs, system, ... }:
let
  lib = pkgs.lib;
  if-tablet = pkgs.lib.mkIf config.programs.plasma.enable;

  alacritty = import ./alacritty.nix { inherit pkgs; };
  firefox = import ./firefox.nix { inherit pkgs; };
  kitty = import ./kitty.nix { inherit pkgs; };
  mpv = import ./mpv.nix { inherit pkgs; };
in
{
  home.packages = if-tablet (builtins.attrValues {
    inherit (pkgs) maliit-keyboard;
    emacs = inputs.emacspkg.packages.${system}.default;

    retroarch = pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
        pcsx-rearmed
        snes9x
        swanstation
      ];
    };
  });

  programs = if-tablet {
    inherit alacritty firefox kitty mpv;

    feh.enable = true;

    bash.shellAliases.win = "sway";
    zsh.shellAliases.win = "sway";

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
      workspace.lookAndFeel = "org.kde.breezedark.desktop";
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
