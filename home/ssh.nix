{ pkgs, ... }:
let
  inherit (builtins) concatStringsSep replaceStrings sort stringLength;
  inherit (pkgs.lib) stringToCharacters;

  rot13 = replaceStrings
    (stringToCharacters "abcdefghijklmnopqrstuvwxyz")
    (stringToCharacters "nopqrstuvwxyzabcdefghijklm");
  obfuscatedId = ["489" "m" "u2" ];
  obfuscatedHost = [ ".e" "p.arg" "fla" ];
  unshuffle = sort (a: b: (stringLength a) < (stringLength b));
  rid = rot13 (concatStringsSep "" (unshuffle obfuscatedId));
  rhost = rot13 (concatStringsSep "" (unshuffle obfuscatedHost));
in
{
  enable = true;
  matchBlocks = {
    rnet = {
      user = rid;
      hostname = rid + rhost;
      extraOptions = {
        AddressFamily = "inet";
      };
    };
  };
}
