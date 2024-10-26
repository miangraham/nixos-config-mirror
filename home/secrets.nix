{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      s2k-count = "65011712";
    };
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-shared = true;
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    pinentryPackage = pkgs.pinentry-gtk2;
    extraConfig = ''
      no-allow-external-cache
    '';
  };
}
