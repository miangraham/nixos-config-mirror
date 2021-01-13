let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  secrets = import ./secrets.nix {};
in
{
  programs = {
    inherit (secrets.programs) gpg password-store;

    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "emacs -nw";
      };
      profileExtra = ''
        source ~/.profile.private
      '';
      shellAliases = {
        ls = "exa --color-scale --group --git";
      };
    };

    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-wlrobs
      ];
    };

    starship = {
      enable = true;
      package = pkgs.starship;
      settings = {
        aws.disabled = true;

        character = {
          style_success = "bold green";
          style_failure = "bold green";
          symbol = "λ";
        };

        cmd_duration.disabled = true;
        hostname.ssh_only = false;
        username.show_always = true;
      };
    };
  };

  services = {
    inherit (secrets.services) gpg-agent;

    kanshi = {
      enable = true;
      package = pkgs.kanshi;
      extraConfig = ''
output "Ancor Communications Inc ROG PG279Q G1LMQS019376" mode 2560x1440 position 0,0
      '';
    };
  };
}
