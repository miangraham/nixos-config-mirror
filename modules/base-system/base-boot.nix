{ pkgs, ... }:
{
  boot = {
    # 6.12 LTS
    kernelPackages = pkgs.linuxPackages_6_12;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };
  };
}
