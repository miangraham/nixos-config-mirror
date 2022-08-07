{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    extraConfig = ''
      no-allow-external-cache
    '';
  };
}
