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
    enable = true;
  };

  nginx = {
    # not currently in use anywhere
    enable = true;
    user = "nginx";
    # user = "ian"; # XXX
    # package = (pkgs.nginx.override {modules = [rtmp];});
    virtualHosts."testlocal.ian.tokyo" = {
      root = "/var/www";
      addSSL = true;
      enableACME = true;
      # root = "/home/ian/yewtest";
      # root = "/home/ian/gst-examples/webrtc/sendrecv/js";
      # extraConfig = ''
      #   location / {}
      # '';
    };
    # appendConfig = ''
    #   rtmp {
    #     server {
    #       listen 1935;
    #       chunk_size 4000;
    #       application ingest {
    #         live on;
    #         record off;
    #         meta copy;

    #         on_publish http://127.0.0.1:8080/auth_publish;

    #         exec systemd-cat -t ingest /home/ian/.bin/handleRtmpIngest.sh $name;
    #       }
    #     }
    #   }
    # '';
  };
}
