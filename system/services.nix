{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  rtmp = import ./rtmp.nix {inherit pkgs;};
in
{
  openssh.enable = true;

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
  };

  nginx = {
    # not currently in use anywhere
    enable = false;
    package = (pkgs.nginx.override {modules = [rtmp];});
    virtualHosts._ = {
      root = "/home/ian/www";
      # root = "/home/ian/yewtest";
    };
    appendConfig = ''
      rtmp {
        server {
          listen 1935;
          chunk_size 4000;
          application ingest {
            live on;
            record off;
            meta copy;

            on_publish http://127.0.0.1:8080/auth_publish;

            exec systemd-cat -t ingest /home/ian/.bin/handleRtmpIngest.sh $name;
          }
        }
      }
    '';
  };

  coturn = {
    enable = true;
  };
}
