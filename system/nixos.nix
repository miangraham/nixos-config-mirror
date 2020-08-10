{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  rtmp = import ./rtmp.nix {pkgs=pkgs;};
  fonts = import ./fonts.nix {pkgs=pkgs;};
  packages = import ./packages.nix {};
in
{
  imports = [
    ../common/overlays.nix
    ./bash.nix
    ./network.nix
    ./sway.nix
  ];

  fonts.fonts = fonts;

  environment.systemPackages = packages;

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  time.timeZone = "Asia/Tokyo";

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 100;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  nix.trustedUsers = ["@wheel"];

  users.users.ian = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio"];
  };

  hardware.pulseaudio.enable = true;

  services.openssh.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
  };

  # temp dev nginx
  networking.firewall.allowedTCPPorts = [ 22 80 1935 ];
  services.nginx = {
    enable = true;
    package = (pkgs.nginx.override {modules = [rtmp];});
    virtualHosts._ = {
      root = "/home/ian/www";
    };
    appendConfig = ''
      rtmp {
        server {
          listen 1935;
          chunk_size 4000;
          application vidtest {
            live on;
            record off;
            meta copy;

            on_publish http://127.0.0.1:8080/auth_publish;

            exec systemd-cat -t vidtest /home/ian/vidtest/run_dev.sh;
          }
        }
      }
    '';
  };
}
