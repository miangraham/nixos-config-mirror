{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos.nix
  ];

  system.stateVersion = "20.03";

  networking.hostName = "rin";

  networking.networkmanager.enable = true;

  networking.resolvconf.dnsExtensionMechanism = false;

  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  programs.light.enable = true;
  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  services.fwupd.enable = true;

  # box specific due to ACME, rip
  services.nginx = {
    enable = false;
    user = "nginx";
    virtualHosts._ = {
      root = "/var/www";
    };
  };

  programs.steam.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 80 443 8443 8989 ];
}
