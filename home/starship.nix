{ pkgs, ... }:
{
  enable = true;
  package = pkgs.starship;
  settings = {
    aws.disabled = true;
    package.disabled = true;

    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold green)";
    };

    # cmd_duration.disabled = true;
    cmd_duration = {
      min_time = 5000;
    };
    # hostname.ssh_only = false;
    # username.show_always = true;
    nix_shell.heuristic = true;
  };
}
