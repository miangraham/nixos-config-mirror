{ pkgs, inputs, ... }:
let
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });

  ffmpegPatch = "${inputs.ffmpeg-patch}/patches/ffmpeg/0001-Fixes-ticket-9086.patch";

  ffmpegOverlay = (self: super: {
    ffmpeg = super.ffmpeg.overrideAttrs(old: {
      patches = old.patches ++ [ ffmpegPatch ];
    });
  });
in
[
  tdOverlay
  inputs.emacs-overlay.overlay
  ffmpegOverlay
]
