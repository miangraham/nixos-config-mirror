{ config, pkgs, inputs, lib, modulesPath, ... }:
let
  syncScript = pkgs.writeScript "euremote-sync.py" ''
    #!${pkgs.python3}/bin/python
    import subprocess

    src_loc = "euremote:/done/"
    dest_loc = "/home/ian/share/euremote/"
    mullvad_bin = "${pkgs.mullvad}/bin/mullvad"
    rclone_bin = "${pkgs.rclone}/bin/rclone"

    mullvad_stat = subprocess.check_output([mullvad_bin, "status"]).decode("utf-8")
    print("Mullvad: " + mullvad_stat, flush=True)
    if not mullvad_stat.startswith("Connected"):
      print("Mullvad offline. Abort.")
      sys.exit(1)

    subprocess.call([rclone_bin, "copy", "--size-only", "--verbose", src_loc, dest_loc])

    print("Done.")
  '';
in {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad;
  };

  systemd.services.euremote-sync = {
    serviceConfig = {
      Type = "oneshot";
      User = "ian";
    };
    script = "${syncScript}";
  };
  systemd.timers.euremote-sync = {
    wantedBy = [ "timers.target" ];
    partOf = [ "euremote-sync.service" ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitInactiveSec = 180;
    };
  };
}