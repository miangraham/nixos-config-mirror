{ pkgs, ... }:
{
  enable = true;
  package = pkgs.git;
  userName = "M. Ian Graham";
  userEmail = import ../common/email.nix {};
  ignores = [
    "*~"
    ".direnv"
    ".emacs.desktop*."
    ".envrc"
    ".indium.json"
    ".projectile"
    ".stack-work"
    "__pycache__"
    "dir-locals.el"
    "node_modules"
  ];
  extraConfig = {
    init.defaultBranch = "master";
  };
  signing = {
    key = "8CE3 2906 516F C4D8 D373  308A E189 648A 55F5 9A9F";
    signByDefault = true;
  };
}
