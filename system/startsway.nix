{ pkgs, ... }:
(
  pkgs.writeTextFile {
    name = "startsway";
    destination = "/bin/win";
    executable = true;
    text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
  '';
  }
)
