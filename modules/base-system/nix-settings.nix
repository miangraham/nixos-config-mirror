{ pkgs, ... }:
{
  package = pkgs.nixVersions.stable;
  channel.enable = false;
  settings = {
    allowed-users = ["@wheel" "nix-ssh"];
    trusted-users = ["@wheel"];
    auto-optimise-store = true;
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  gc = {
    automatic = true;
    dates = "Sat *-*-* 00:00:00";
    options = "--delete-older-than 14d";
  };
  extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';
}
