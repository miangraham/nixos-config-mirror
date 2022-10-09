{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dicod;

  gcide = pkgs.stdenv.mkDerivation rec {
    name = "gcide";
    src = pkgs.fetchurl {
      url = "mirror://gnu/gcide/gcide-0.53.tar.xz";
      sha256 = "sha256-06y9mE3hzgItXROZA4h7NiMuQ24w7KLLD7HAWN1/MZ8=";
    };
    nativeBuildInputs = [ pkgs.dico ];
    buildPhase = ''
      ${pkgs.dico}/libexec/idxgcide .
    '';
    installPhase = ''
      mkdir -p $out
      cp * $out/
    '';
  };

  wiktionary = pkgs.dictdDBs.wiktionary;
  wordnet = pkgs.dictdDBs.wordnet;
in

{

  ###### interface

  options = {

    services.dicod = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the GNU Dico dictionary server.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 2628;
        description = lib.mdDoc "Listen port";
      };

      enableGCIDE = mkOption {
        type = types.bool;
        default = true;
      };

      enableWiktionary = mkOption {
        type = types.bool;
        default = true;
      };

      enableWordnet = mkOption {
        type = types.bool;
        default = true;
      };

      dictOrgDbs = mkOption {
        type = types.listOf types.package;
        default = with pkgs.dictdDBs; [ ];
        defaultText = literalExpression "with pkgs.dictdDBs; [ ]";
        example = literalExpression "[ pkgs.dictdDBs.nld2eng ]";
        description = lib.mdDoc "List of databases to make available.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Extra text appended to dicod.conf verbatim.";
      };
    };

  };

  ###### implementation

  config = let
    langFromToMap = {
      "deu-eng" = ["de" "en"];
      "eng-deu" = ["en" "de"];
      "nld-eng" = ["nl" "en"];
      "eng-nld" = ["en" "nl"];
      "rus-eng" = ["ru" "en"];
      "eng-rus" = ["en" "ru"];
      "fra-eng" = ["fr" "en"];
      "eng-fra" = ["en" "fr"];
      "jpn-eng" = ["jp" "en"];
      "eng-jpn" = ["en" "jp"];
    };

    dbToFromToConf = dbPkg: if
      (hasAttr "dbName" dbPkg) &&
      (hasAttr dbPkg.dbName langFromToMap)
      then ''
        languages-from "${elemAt (getAttr dbPkg.dbName langFromToMap) 0}";
        languages-to "${elemAt (getAttr dbPkg.dbName langFromToMap) 1}";
      '' else ""
    ;

    dbToConfig = dbPkg: ''
      database {
        name "${dbPkg.dbName}";
        handler "dictorg database=${dbPkg}/share/dictd/${dbPkg.dbName}";
        ${dbToFromToConf dbPkg}
      }
    '';

    portConf = "listen :${builtins.toString cfg.port};";

    gcideConf = if cfg.enableGCIDE then ''
      load-module gcide;

      database {
        name "gcide";
        handler "gcide dbdir=${gcide} suppress-pr";
        languages-from "en";
        languages-to "en";
      }
    '' else "";

    wiktionaryConf = if cfg.enableWiktionary then ''
      database {
        name "wiktionary";
        handler "dictorg database=${wiktionary}/share/dictd/wiktionary-en";
        languages-from "en";
        languages-to "en";
      }
    '' else "";

    wordnetConf = if cfg.enableWiktionary then ''
      database {
        name "wordnet";
        handler "dictorg database=${wordnet}/share/dictd/wn";
        languages-from "en";
        languages-to "en";
      }
    '' else "";

    dictOrgDbConf = concatMapStringsSep "\n" dbToConfig cfg.dictOrgDbs;

    dicod-conf = pkgs.writeTextFile {
      name = "dicod.conf";
      text = ''
        ${portConf}
        ${gcideConf}
        load-module dictorg {
          command "dictorg";
        }
        ${dictOrgDbConf}
        ${wiktionaryConf}
        ${wordnetConf}
        '' + cfg.extraConfig;
    };
  in mkIf cfg.enable {

    environment.systemPackages = [ pkgs.dico ];

    users.users.dicod = {
      group = "dicod";
      description = "GNU dicod server";
      home = "/var/dictdb";
      isSystemUser = true;
    };

    users.groups.dicod = {};

    systemd.services.dicod = {
      description = "GNU dico dictionary server";
      path = [ gcide ];
      serviceConfig = {
        Type = "simple";
        User = "dicod";
      };
      wantedBy = [ "multi-user.target" ];
      environment = { LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive"; };
      # serviceConfig.Type = "forking";
      script = "${pkgs.dico}/bin/dicod --foreground --stderr --config=${dicod-conf}";
    };
  };
}
