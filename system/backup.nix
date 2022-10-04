{ pkgs, backupTime, ... }:
let
  inherit (import ./backup-shared.nix {inherit pkgs backupTime;}) job;
in
{
  borgbackup.jobs.home-ian-to-local = job {
    repo = "/borg";
    user = "root";
    preHook = ''
      mkdir -p /borg
    '';
  };

  borgbackup.jobs.home-ian-to-homura = job {
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
}
