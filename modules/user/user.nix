{ pkgs, inputs, config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.ian = import ../../home {};
  };

  users.users.ian = {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = import ./ssh-auth-keys.nix {};
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "dicod"
      "gpio"
      "i2c"
      "libvirtd"
      "lirc"
      "networkmanager"
      "nginx"
      "spi"
      "storage"
      "video"
      "wheel"
      "znc"
    ];
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ian";
    dataDir = "/home/ian/share";
    configDir = "/home/ian/.config/syncthing";
    extraFlags = [ "--no-default-folder" ];
  };

  systemd.services.pre-syncthing = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    wantedBy = [ "syncthing.service" ];
    path = [ pkgs.coreutils ];
    script = ''
      mkdir -p /home/ian/share
      chown ian:syncthing /home/ian/share
    '';
  };
}
