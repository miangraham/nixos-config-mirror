{ pkgs, lib, inputs, config, ... }:
with lib;
{
  options.my.backup.home-to-local = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to back up home to /borg.";
    };
  };

  options.my.backup.home-to-ranni = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to back up home to ranni.";
    };
  };

  options.my.backup.home-to-rnet = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to back up home to rnet.";
    };
  };

  options.my.backup.home-to-usb = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to back up home to rnet.";
    };

    repo = mkOption {
      type = path;
      default = "";
      description = mdDoc "Full path to destination repo on removable drive.";
    };
  };

  options.my.backup.srv-to-ranni = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to back up server data to ranni.";
    };

    paths = mkOption {
      type = listOf path;
      default = [];
      description = mdDoc "Server data paths to back up.";
    };
  };

  # TODO: service name change?
  config.services.borgbackup.jobs.home-ian-to-local = mkIf config.my.backup.home-to-local.enable
    (import ./backup-home-to-local.nix { inherit pkgs; });

  # TODO: service name change?
  config.services.borgbackup.jobs.home-ian-to-ranni = mkIf config.my.backup.home-to-ranni.enable
    (import ./backup-home-to-ranni.nix { inherit pkgs config; });

  # TODO: service name change?
  config.services.borgbackup.jobs.home-ian-to-rnet = mkIf config.my.backup.home-to-rnet.enable
    (import ./backup-home-to-rnet.nix { inherit pkgs config; });

  # TODO: service name change?
  config.services.borgbackup.jobs.home-ian-to-usb = mkIf config.my.backup.home-to-usb.enable
    (import ./backup-home-to-usb.nix {
      inherit pkgs config;
      inherit (config.my.backup.home-to-usb) repo;
    });

  config.services.borgbackup.jobs.srv-to-ranni = mkIf config.my.backup.srv-to-ranni.enable
    (import ./backup-srv-to-ranni.nix {
      inherit pkgs config;
      inherit (config.my.backup.srv-to-ranni) paths;
    });
}
