{ pkgs, ... }:
{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  nix = import ../common/nix-settings.nix { inherit pkgs; };

  users.users.ian = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = import ../common/ssh-auth-keys.nix {};
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

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        safe.directory = "/home/ian/.nix";
      };
    };

    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';
  };
}
