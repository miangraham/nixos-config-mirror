{ pkgs, ... }:
{
  package = pkgs.nixVersions.stable;
  channel.enable = false;
  settings = {
    allowed-users = ["@wheel" "nix-ssh"];
    trusted-users = ["@wheel"];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org?priority=20"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
