{ config, pkgs, inputs, ... }:
let
  inherit (builtins) concatStringsSep sort stringLength;
  obfuscatedAddr = [ "in.net" "an" "@ij" "i" ];
  unshuffle = sort (a: b: (stringLength a) < (stringLength b));
  emailAddr = concatStringsSep "" (unshuffle obfuscatedAddr);
  mailWrapper = pkgs.writeShellScriptBin "mail-wrapper" ''
    set -e

    TO_HEADER="To: ${emailAddr}"
    INPUT="$(</dev/stdin)"
    SUB_HEADER="$(echo "''${INPUT}" | head -n 1)"
    MSG_CLEAN=$(echo "''${INPUT}" | tail -n +2)

    echo -e "''${TO_HEADER}\n''${SUB_HEADER}\n\n''${MSG_CLEAN}\n" | ${pkgs.msmtp}/bin/msmtp -C /etc/msmtprc ${emailAddr} >/tmp/smtp_log.txt 2>&1
  '';
in
{
  hardware.sensor.hddtemp = {
    enable = true;
    drives = [
      "/dev/disk/by-id/ata-ST16000NT001-3LV101_WR50FMJJ"
      "/dev/disk/by-id/ata-ST16000NT001-3LV101_WR6039HH"
    ];
    dbEntries = [
      ''"ST16000NT001" 194 C "Seagate Ironwolf Pro 7200 SATA 16TB"''
    ];
  };

  services = {
    zfs = {
      zed.enableMail = false;
      zed.settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";
        ZED_EMAIL_ADDR = [ emailAddr ];
        ZED_EMAIL_PROG = "${mailWrapper}/bin/mail-wrapper";
        ZED_EMAIL_OPTS = "@ADDRESS@";

        ZED_NOTIFY_INTERVAL_SECS = 60;
        ZED_NOTIFY_VERBOSE = true;
      };
    };

    prometheus = {
      enable = true;
      port = 9090;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
        zfs = {
          enable = true;
          pools = [ "srv" ];
        };
        smartctl = {
          enable = true;
          devices = [
            "/dev/sda"
            "/dev/sdb"
          ];
          maxInterval = "10m";
        };
      };
      scrapeConfigs = [{
        job_name = "system";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      } {
        job_name = "zfs";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}" ];
        }];
      } {
        job_name = "smartctl";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}" ];
        }];
      }];
    };

    grafana = {
      enable = true;
      settings.server = {
        domain = "ranni";
        http_port = 8989;
        http_addr = "0.0.0.0";
      };
    };
  };

  systemd.services.diskreport = let
    diskReport = pkgs.writeShellScriptBin "disk-report" ''
      set -e

      file_mtime () {
        NAME=$1
        MTIME=$(date +"%Y-%m-%d_%H:%M:%S" -r $2)
        printf "%-8s: %s\n" $NAME $MTIME
      }

      echo "To: ${emailAddr}"

      echo -e "Subject: Ranni Disk Report\n"

      echo -e "Ranni Disk Report for $(date)\n"

      echo "-- OVERVIEW --"
      zpool list

      echo -e "\n-- HEALTH --"
      zpool status

      echo -e "\n-- USAGE --"
      zfs list -o space,quota,reservation

      echo -e "\n-- BACKUPS --"
      file_mtime bocchi /srv/timemachine/bocchi.sparsebundle/com.apple.TimeMachine.SnapshotHistory.plist
      file_mtime futaba /srv/borg/futaba
      file_mtime maho /srv/timemachine/maho.sparsebundle/com.apple.TimeMachine.SnapshotHistory.plist
      file_mtime megumin /srv/duplicati/megumin
      file_mtime nene /srv/borg/nene
      file_mtime ranni /srv/borg/ranni
      file_mtime rin /srv/borg/rin
      file_mtime yuno /srv/timemachine/yuno.backupbundle/com.apple.TimeMachine.SnapshotHistory.plist
    '';
  in {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      # RemainAfterExit = true;
    };
    # wantedBy = [ "multi-user.target" ];
    environment = {};
    path = [
      pkgs.msmtp
      pkgs.zfs
    ];
    script = ''
      ${diskReport}/bin/disk-report | msmtp -C /etc/msmtprc root
    '';
    startAt = "Mon *-*-* 12:00:00";
  };
}
