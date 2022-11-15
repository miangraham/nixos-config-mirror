{ config, lib, pkgs, inputs, ... }:

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

    guileDBs = mkOption {
      type = listOf package;
      default = [ ];
      defaultText = literalExpression "[ ]";
      example = literalExpression "[ pkgs.dicoGuileDBs.dico-moby-thesaurus ]";
      description = mdDoc ''
        List of guile database packages to make available.
      '';
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

    dicodWithLibs = import ./dicod-with-libs.nix {
      inherit pkgs lib;
      inherit (cfg) guileDBs;
    };

    gcide = pkgs.callPackage ./gcide.nix { dico = dicodWithLibs; };

    dicodConf = import ./dicod-conf.nix {
      inherit pkgs lib pidfile gcide;
      inherit (cfg) port dictdDBs enableGCIDE enableWiktionary enableWordnet guileDBs extraConfig;
    };
  in mkIf cfg.enable {
    environment.systemPackages = [ dicodWithLibs ];

    users.users.dicod = {
      group = "dicod";
      description = "GNU dictionary server";
      isSystemUser = true;
    };

    users.groups.dicod = {};

    systemd.services.dicod = let
    in {
      description = "GNU dictionary server";
      path = [ ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = "dicod";
        # Can't make pidfile without this you dummy
        RuntimeDirectory = [ "dicod" ];
        PIDFile = pidfile;
        ExecStart = "${dicodWithLibs}/bin/dicod --config=${dicodConf}";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
