{ pkgs, ... }:
{
  fwupd.enable = true;
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

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
    extraFlags = [ "--no-default-folder" ];
  };

  # clamav = {
  #   daemon.enable = true;
  #   updater = {
  #     enable = true;
  #     interval = "daily";
  #   };
  # };
}
