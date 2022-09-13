{ pkgs, ... }:
{
  enable = true;
  package = pkgs.starship;
  settings = {
    aws.disabled = true;

    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold green)";
    };

    cmd_duration.disabled = true;
    # hostname.ssh_only = false;
    # username.show_always = true;
  };
}
