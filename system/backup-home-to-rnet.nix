{ pkgs, hostname, ... }:
let
  backupTime = "*-*-* *:02:00";
  inherit (import ./backup-utils.nix {inherit pkgs backupTime;}) job;
in
job {
  repo = "rnet:${hostname}";
  user = "ian";
  doInit = false;
  persistentTimer = true;
  encryption = {
    mode = "keyfile-blake2";
    passCommand = "cat /home/ian/.ssh/rnet_${hostname}_phrase";
  };
  extraArgs = "--remote-path=borg1";
}
