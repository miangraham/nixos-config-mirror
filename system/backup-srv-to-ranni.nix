{ pkgs, hostname, paths, ... }:
let
  backupTime = "*-*-* 04:15:00";
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
job {
  inherit paths;
  repo = "borg@ranni:${hostname}";
  user = "root";
  persistentTimer = true;
  environment.BORG_RSH = "ssh -i /home/ian/.ssh/id_ed25519";
  environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
  prune = {
    keep = {
      hourly = 0;
      daily = 7;
      weekly = 3;
      monthly = 3;
    };
  };
}
