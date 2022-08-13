{ obs-studio, obs-studio-plugins, symlinkJoin, makeWrapper, writeShellScriptBin }:
let
  plug = obs-studio-plugins.obs-websocket;
in
writeShellScriptBin "obs" ''
  OBS_PLUGINS_PATH="${plug}/lib/obs-plugins" \
  OBS_PLUGINS_DATA_PATH="${plug}/share/obs/obs-plugins" \
  ${obs-studio}/bin/obs
''
