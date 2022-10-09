{ pkgs, dev, ... }:
let
  gcide = import ./gcide.nix { inherit pkgs; };
in
{
  earlyoom.enable = true;
  udisks2.enable = true;
  gnome.gnome-keyring.enable = true;

  pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
  };

  dicod = {
    enable = true;
    dictdDBs = with pkgs.dictdDBs; [
      dev.dictdDBs.eng2jpn
      dev.dictdDBs.jpn2eng
     ];
  };
}
