{ pkgs, inputs, ... }:
let
  tdOverlay = (self: super: {
    tdlib = super.tdlib.overrideAttrs(old: {
      version = "unstable";
      src = inputs.tdlib;
    });
  });

  ffmpegOverlay = (self: super: {
    ffmpeg = super.ffmpeg.overrideAttrs(old: {
      patches = old.patches ++ [ ./ffmpeg.patch ];
    });
  });
in
[
  tdOverlay
  inputs.emacs-overlay.overlay
  ffmpegOverlay
]
