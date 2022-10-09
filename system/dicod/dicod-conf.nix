{
  pkgs,
  lib,
  pidfile,
  dicoWithLibs,
  gcide,
  port,
  dictdDBs,
  enableGCIDE,
  enableWiktionary,
  enableWordnet,
  extraConfig,
}:
with lib;
let
  ## helpers

  dbSection = { name, handler, description ? null, from ? "en", to ? "en" }: ''
    database {
      name "${name}";
      ${if isString description then ''description "${description}";'' else ""}
      handler "${handler}";
      languages-from "${from}";
      languages-to "${to}";
    }
  '';

  dictOrgDbSection = { name, pkg, fileBaseName, description ? null, from ? "en", to ? "en" }:
    dbSection {
      inherit name from to description;
      handler = "dictorg database=${pkg}/share/dictd/${fileBaseName}";
    };

  # Hacky bilingual language code grabbing from pkg.dbName.
  # It's this or a lookup table or adding more flags to the dictdDB data.
  dbToLangs = dbPkg: with builtins; let
    dbName = dbPkg.dbName or "";
    matched = match "(...)-(...)" dbName;
    pair = if matched != null then matched else ["eng" "eng"];
    langs = map (substring 0 2) pair;
  in
    mapAttrs (_: elemAt langs) { from = 0; to = 1; };

  dictOrgToConf = pkg: dictOrgDbSection {
    inherit pkg;
    name = pkg.dbName;
    fileBaseName = pkg.dbName;
    inherit (dbToLangs pkg) from to;
  };

  ## conf sections

  pidfileConf = "pidfile ${pidfile};";

  listenConf = "listen :${builtins.toString port};";

  dictOrgDbConf = ''
    load-module dictorg {
      command "dictorg";
    }
  '' + (concatMapStringsSep "\n" dictOrgToConf dictdDBs);

  # Use dicod's native GCIDE support.
  gcideConf = ''
    load-module gcide;
  '' + dbSection {
    name = "gcide";
    handler = "gcide dbdir=${gcide} suppress-pr";
  };

  # Package structure is different from the other dictd DBs and needs an override.
  wiktionaryConf = let pkg = pkgs.dictdDBs.wiktionary; in dictOrgDbSection {
    inherit pkg;
    name = "wiktionary";
    fileBaseName = "wiktionary-en";
    description = "English-language Wiktionary, version ${pkg.version}";
  };

  # Use dicod's native wordnet support.
  wordnetConf = ''
    load-module wordnet {
      command "wordnet";
    }
  '' + dbSection {
    name = "wordnet";
    handler = "wordnet merge-defs";
    description = "WordNet dictionary, version ${pkgs.wordnet.version}";
  };
in
pkgs.writeTextFile {
  name = "dicod.conf";
  text = concatStringsSep "\n" [
    pidfileConf
    listenConf
    dictOrgDbConf
    (if enableGCIDE then gcideConf else "")
    (if enableWiktionary then wiktionaryConf else "")
    (if enableWordnet then wordnetConf else "")
    extraConfig
  ];
}
