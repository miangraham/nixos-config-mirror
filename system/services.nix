{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  rtmp = import ./rtmp.nix {inherit pkgs;};
  backup = import ./backup.nix {inherit pkgs;};
in
{
  inherit (backup) borgbackup;

  openssh.enable = true;

  earlyoom.enable = true;

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
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
