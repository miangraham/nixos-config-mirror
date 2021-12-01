{ pkgs, ... }:
let
  rtmp = import ./rtmp.nix {inherit pkgs;};
in
{
  pipewire = {
    enable = true;
    pulse.enable = true;
  };

  openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  earlyoom.enable = true;

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
  };

  udisks2 = {
    enable = true;
  };

  coturn = {
    enable = false;
  };

  rabbitmq = {
    enable = false;
  };
}
