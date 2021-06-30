{ pkgs, ... }:
(
  pkgs.writeTextFile {
    name = "startsway";
    destination = "/bin/win";
    executable = true;
    text = ''
           #! ${pkgs.bash}/bin/bash -e

           sway
           '';
  }
)
