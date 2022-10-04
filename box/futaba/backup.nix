{ pkgs, ... }:
let
  backupTime = "*-*-* *:04:00";
  backup = import ../../system/backup.nix {
    inherit pkgs backupTime;
  };
  inherit (import ../../system/backup-shared.nix {inherit pkgs backupTime;}) job;
  jobs = {
    rss-to-local = job {
      paths = [ "/srv/freshrss" ];
      startAt = "*-*-* *:07:00";
      repo = "/borg";
      user = "root";
      preHook = ''
        mkdir -p /borg
      '';
    };

    music-to-homura = job {
      paths = [ "/srv/music" ];
      startAt = "*-*-* *:47:00";
      repo = "/home/ian/mounts/homuraborg";
      user = "ian";
      doInit = false;
      preHook = ''
        mkdir -p /home/ian/mounts/homuraborg
        /run/current-system/sw/bin/sshfs borg@homura:/share/MD0_DATA/nixborg /home/ian/mounts/homuraborg
      '';
      postHook = ''
        /run/wrappers/bin/fusermount3 -u /home/ian/mounts/homuraborg
      '';
      extraArgs = "--lock-wait 30";
      environment = {
        BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
        BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      };
    };

    music-to-rnet = {
      repo = "rnet:futaba";
      paths = [ "/srv/music" ];
      user = "ian";
      doInit = false;
      startAt = "daily";
      prune = {
        keep = {
          daily = 3;
          weekly = 3;
          monthly = 3;
        };
      };
      compression = "auto,zstd";
      extraArgs = "--remote-path=borg1";
      encryption = {
        mode = "keyfile-blake2";
        passCommand = "cat /home/ian/.ssh/rnet_futaba_phrase";
      };
    };
  };
in
pkgs.lib.recursiveUpdate backup.borgbackup { inherit jobs; }
