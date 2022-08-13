{ obs-studio, obs-studio-plugins, symlinkJoin, makeWrapper, writeShellScriptBin }:
let
  paths = [ obs-studio-plugins.obs-websocket ];
  plugins = symlinkJoin {
    name = "obs-plugins-joined";
    inherit paths;
  };
in
writeShellScriptBin "obs" ''
  OBS_PLUGINS_PATH="${plugins}/lib/obs-plugins" \
  OBS_PLUGINS_DATA_PATH="${plugins}/share/obs/obs-plugins" \
  ${obs-studio}/bin/obs --verbose
''
