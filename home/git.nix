{ ... }:
let
  conf = import ../system/config.nix {};
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs conf;
  obfuscatedAddr = [
    "am"
    "es@"
    ""
    "graham.com"
    "g"
    ""
    "mian"
  ];
  deobfuscate = builtins.sort (a: b: (builtins.stringLength a) < (builtins.stringLength b));
  addr = builtins.concatStringsSep "" (deobfuscate obfuscatedAddr);
in
{
  enable = true;
  package = pkgs.git;
  userName = "M. Ian Graham";
  userEmail = addr;
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
  ];
}
