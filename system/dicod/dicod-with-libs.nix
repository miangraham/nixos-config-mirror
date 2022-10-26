{ pkgs,
  lib,
  guileDBs,
  ...
}:
pkgs.dico.overrideAttrs (final: old: {
  nativeBuildInputs = with pkgs; old.nativeBuildInputs ++ [
    autoconf
    gettext
    gsasl
    guile
    libffi
    libtool
    makeWrapper
    m4
    pcre
    perl
    pkg-config
    python3
    readline
    zlib
  ];

  buildInputs = with pkgs; old.buildInputs ++ guileDBs ++ [
    wordnet
  ];

  patches = [
    ./fix-guile-tests.patch
  ];

  postInstall =
    let
      guileVersion = lib.versions.majorMinor pkgs.guile.version;
    in
    ''
      wrapProgram $out/bin/dicod \
        --prefix GUILE_LOAD_PATH : "$out/share/guile/site/${guileVersion}:$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$out/lib/guile/${guileVersion}/site-ccache:$GUILE_LOAD_COMPILED_PATH"
    '';
})
