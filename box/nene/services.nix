{ pkgs, inputs, config, ... }:
let
  unstable = import ../../common/unstable.nix {inherit pkgs inputs;};
  backup = import ../../system/backup.nix {
    inherit pkgs;
    backupTime = "*-*-* *:02:00";
  };
in
{
  nix = {
    sshServe = {
      enable = true;
      protocol = "ssh-ng";
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcbC9h0gXGiyRCKE4Pj8jJ4loQ89QyeG7m3H2hLm6Fc ian@futaba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9bJ3HUVayNr8yYcE5WO/geJD7wjOmtYx+Nc5hcR7DS root@futaba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtZ9GKY548o3w65T0HAQjULyuKthQzenZ36LO18brZo ian@rin"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfZ7KtcLJWYJTNcoj2fJM9orUo/CJAQmpXihBCU6SSE root@rin"
      ];
    };
    extraOptions = ''
      secret-key-files = /var/keys/nix-cache-key.priv
    '';
  };

  services = {
    inherit (backup) borgbackup;

    # box specific due to ACME, rip
    nginx = {
      enable = true;
      user = "nginx";
      virtualHosts = {
        nene = {
          serverName = "localhost";
          locations."/" = {
            return = "404";
          };
        };

        "testlocal.ian.tokyo" = {
          serverName = "testlocal.ian.tokyo";
          root = "/var/www";
          addSSL = true;
          enableACME = true;
        };
      };
    };

    searx = {
      enable = true;
      settings = {
        server.port = 8989;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
      };
      environmentFile = /home/ian/.config/searx/env;
    };

    znc = {
      enable = true;
      confOptions = {
        passBlock = "";
      };
      # extraFlags = [ "--debug" ];
    };
  };

  security.acme = {
    email = "spamisevil@ijin.net";
    acceptTerms = true;
  };

  systemd.services.pueue = {
    serviceConfig = {
      Type = "simple";
      User = "ian";
    };
    wantedBy = [ "multi-user.target" ];
    path = [
      unstable.pueue
      unstable.yt-dlp
      unstable.aria2
    ];
    script = "pueued -v";
  };
}
