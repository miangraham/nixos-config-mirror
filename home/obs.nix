{ obs-studio, symlinkJoin, makeWrapper }:

{ plugins ? [] }:

let
  plugins-joined = symlinkJoin {
    name = "obs-plugins";
    paths = plugins;
  };
in
symlinkJoin {
  name = "wrapped-${obs-studio.name}";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ obs-studio ];

  postBuild = ''
    wrapProgram $out/bin/obs \
      --set OBS_PLUGINS_PATH      "${plugins-joined}/lib/obs-plugins" \
      --set OBS_PLUGINS_DATA_PATH "${plugins-joined}/share/obs/obs-plugins"
  '';

  inherit (obs-studio) meta;
  passthru = obs-studio.passthru // {
    passthru.unwrapped = obs-studio;
  };
}
