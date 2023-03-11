{ pkgs, ... }:
let
  inherit (builtins) concatStringsSep sort stringLength;
  obfuscatedAddr = [ "in.net" "an" "@ij" "i" ];
  unshuffle = sort (a: b: (stringLength a) < (stringLength b));
  emailAddr = concatStringsSep "" (unshuffle obfuscatedAddr);
in {
  email = {
    certificatesFile = ./pmbridge_cert.pem;
    maildirBasePath = ".mail";
    accounts = {
      pmbridge = {
        primary = true;
        realName = "M. Ian Graham";
        address = emailAddr;
        userName = emailAddr;
        passwordCommand = "cat /home/ian/.ssh/pmbridge_pass";
        aliases = [];
        maildir.path = "";
        mbsync = {
          enable = true;
          create = "maildir";
        };
        mu.enable = true;
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
      };
    };
  };
}
