{ pkgs, inputs, ... }:
let
  ffmpegPatch = "${inputs.ffmpeg-patch}/patches/ffmpeg/0001-Fixes-ticket-9086.patch";

  ffmpegOverlay = (self: super: {
    ffmpeg = super.ffmpeg.overrideAttrs(old: {
      patches = old.patches ++ [ ffmpegPatch ];
    });
  });

  conf = {
    inherit (pkgs) system;
    overlays = [ ffmpegOverlay ];
  };
in
(import inputs.unstable conf).pkgs.yt-dlp
