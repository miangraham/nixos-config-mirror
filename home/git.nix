{ ... }:
let
  pkgs = import ../common/stable.nix {};

  obfuscatedAddr = ["es@" "am" "" "graham" "g" "" "mian"];
  unshuffle = builtins.sort (a: b: (builtins.stringLength a) < (builtins.stringLength b));
  userEmail = builtins.concatStringsSep "" ((unshuffle obfuscatedAddr) ++ [".com"]);
in
{
  enable = true;
  package = pkgs.git;
  userName = "M. Ian Graham";
  inherit userEmail;
  ignores = [
    "*~"
    ".projectile"
    ".emacs.desktop*."
    "dir-locals.el"
    "node_modules"
    ".stack-work"
    ".indium.json"
    ".envrc"
    ".direnv"
    "__pycache__"
  ];
}
