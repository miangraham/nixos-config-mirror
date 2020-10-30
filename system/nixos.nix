{ ... }:
let
  conf = import ./config.nix {};
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs conf;
  unstable = import sources.nixpkgs-unstable conf;
  rtmp = import ./rtmp.nix {pkgs=pkgs;};
  fonts = import ./fonts.nix {pkgs=pkgs;};
  packages = import ./packages.nix {};
  overlays = import ../common/overlays.nix {};
in
{
  imports = [
    ./bash.nix
    ./network.nix
    ./sway.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
    overlays = overlays;
  };

  fonts.fonts = fonts;
  fonts.fontconfig.disableVersionedFontConfiguration = true;

  environment.systemPackages = packages;

  time.timeZone = "Asia/Tokyo";

  boot.kernelPackages = unstable.linuxPackages_5_8;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 100;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  nix.trustedUsers = ["@wheel"];

  users.users.ian = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video"];
  };

  hardware.pulseaudio.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # extraLocaleSettings = {
    #   LC_CTYPE = "ja_JP.UTF-8";
    # };
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };

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
}
