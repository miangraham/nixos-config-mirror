{ ... }:
let
  inherit (builtins) concatStringsSep sort stringLength;
  obfuscatedAddr = ["es@" "am" "" "graham" "g" "" "mian"];
  unshuffle = sort (a: b: (stringLength a) < (stringLength b));
in
concatStringsSep "" ((unshuffle obfuscatedAddr) ++ [".com"])
