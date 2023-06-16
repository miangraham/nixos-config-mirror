{ pkgs, ... }:
{
  earlyoom.enable = true;
  fwupd.enable = true;
  gnome.gnome-keyring.enable = true;
  tailscale.enable = true;
  udisks2.enable = true;

  openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
  };

  clamav = {
    daemon.enable = true;
    updater = {
      enable = true;
      interval = "daily";
    };
  };
}
