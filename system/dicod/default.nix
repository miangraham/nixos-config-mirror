{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dicod;
in
{

  ###### interface

  options.services.dicod = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to enable the GNU dictionary server.";
    };

    port = mkOption {
      type = port;
      default = 2628;
      description = mdDoc "Port where dicod will listen for lookup requests.";
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = mdDoc "Whether to create firewall rules to allow outside access via the port in {option}`services.dicod.port`.";
    };

    dictdDBs = mkOption {
      type = listOf package;
      default = [ ];
      defaultText = literalExpression "[ ]";
      example = literalExpression "[ pkgs.dictdDBs.nld2eng ]";
      description = mdDoc ''
        List of dictd database packages to make available.
        Expects results of `makeDictdDBFreedict`.
        For unusual file layouts, use `extraConfig` to roll your own database section.
      '';
    };

    enableGCIDE = mkOption {
      type = bool;
      default = true;
      description = mdDoc "Whether to enable the database for GNU Collaborative International Dictionary of English.";
    };

    enableWiktionary = mkOption {
      type = bool;
      default = true;
      description = mdDoc "Whether to enable the database for Wiktionary.";
    };

    enableWordnet = mkOption {
      type = bool;
      default = true;
      description = mdDoc "Whether to enable the database for WordNet.";
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = mdDoc "Extra text appended to dicod.conf verbatim.";
    };
  };

  ###### implementation

  config = let
    pidfile = "/run/dicod/dicod.pid";

    dicoWithLibs = pkgs.dico.overrideAttrs (final: old: {
      buildInputs = [ pkgs.wordnet ] ++ old.buildInputs;
    });

    gcide = pkgs.callPackage ./gcide.nix { dico = dicoWithLibs; };

    dicod-conf = import ./dicod-conf.nix {
      inherit pkgs lib pidfile dicoWithLibs gcide;
      inherit (cfg) port dictdDBs enableGCIDE enableWiktionary enableWordnet extraConfig;
    };
  in mkIf cfg.enable {
    environment.systemPackages = [ dicoWithLibs ];

    users.users.dicod = {
      group = "dicod";
      description = "GNU dictionary server";
      isSystemUser = true;
    };

    users.groups.dicod = {};

    systemd.services.dicod = {
      description = "GNU dictionary server";
      path = [ ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = "dicod";
        RuntimeDirectory = [ "dicod" ];
        PIDFile = pidfile;
        ExecStart = "${dicoWithLibs}/bin/dicod --config=${dicod-conf}";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
