{ pkgs, ... }:
{
  gnome.gnome-keyring.enable = true;
  udisks2.enable = true;

  openssh = {
    enable = true;
    settings = {
      Macs = [
        "hmac-sha2-512"
        "hmac-sha2-256"
      ];
      PermitRootLogin = "no";
    };
  };
}
