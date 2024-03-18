{ pkgs, inputs, config, ... }:
let
  inherit (import ../../system/backup-utils.nix {
    inherit pkgs;
    backupTime = "*-*-* *:10:00";
  }) job;
in
{
  services = {
    nebula.networks.asgard.firewall.inbound = [
      { port = 3001; proto = "tcp"; host = "any"; } # uptime-kuma
    ];
    udisks2.enable = true;
    openssh = {
      enable = true;
      settings = {
        Macs = [
          "hmac-sha2-512"
          "hmac-sha2-256"
        ];
        PermitRootLogin = "no";
      };
    };
    borgbackup.jobs.home-ian-to-usb = job {
      repo = "/run/media/ian/70F8-1012/borg";
      user = "ian";
      doInit = false;
      removableDevice = true;
    };
    endlessh = {
      enable = true;
      openFirewall = true;
    };
  };

  systemd.services.udiskie = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.udiskie
      pkgs.xdg_utils
    ];
    script = "udiskie -aNT";
  };

  security.polkit.extraConfig = ''
polkit.addRule(function(action, subject) {
  var YES = polkit.Result.YES;
  var permission = {
    // required for udisks1:
    "org.freedesktop.udisks.filesystem-mount": YES,
    "org.freedesktop.udisks.luks-unlock": YES,
    "org.freedesktop.udisks.drive-eject": YES,
    "org.freedesktop.udisks.drive-detach": YES,
    // required for udisks2:
    "org.freedesktop.udisks2.filesystem-mount": YES,
    "org.freedesktop.udisks2.encrypted-unlock": YES,
    "org.freedesktop.udisks2.eject-media": YES,
    "org.freedesktop.udisks2.power-off-drive": YES,
    // required for udisks2 if using udiskie from another seat (e.g. systemd):
    "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
    "org.freedesktop.udisks2.filesystem-unmount-others": YES,
    "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
    "org.freedesktop.udisks2.eject-media-other-seat": YES,
    "org.freedesktop.udisks2.power-off-drive-other-seat": YES
  };
  if (subject.isInGroup("storage")) {
    return permission[action.id];
  }
});
  '';
}
