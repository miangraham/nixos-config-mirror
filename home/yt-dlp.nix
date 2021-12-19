{ pkgs, inputs, ... }:
let
  ffmpegPatch = "${inputs.ffmpeg-patch}/patches/ffmpeg/0001-Fixes-ticket-9086.patch";

  ffmpegOverlay = (self: super: {
    ffmpeg = super.ffmpeg.overrideAttrs(old: {
      patches = old.patches ++ [ ffmpegPatch ];
    });
  });

  overlays = [ ffmpegOverlay ];

  conf = {
    inherit (pkgs) system;
    inherit overlays;
    config.allowUnfree = true;
  };

  newpkgs = (import inputs.unstable conf).pkgs;
in
newpkgs.yt-dlp
