{ pkgs, backupTime, ... }:
let
  home-path = "/home/ian";

  exclude-home-paths = [
    "downloads"
    "git"
    "mounts"
    "music"
    "nixpkgs"
    "recording"
    "tmp"
    "videos"
    "zotero"

    ".bin/go"
    ".cabal"
    ".cache"
    ".cargo"
    ".compose-cache"
    ".debug"
    ".emacs.d/eln-cache"
    ".gnupg"
    ".kodi"
    ".local/share"
    ".local/unity3d"
    ".m2"
    ".mozilla"
    ".npm"
    ".paradoxlauncher"
    ".pki"
    ".rustup"
    ".ssh"
    ".steam"
    ".telega"
    ".tldrc"
    ".vscode"
    ".zoom"
    ".zotero"

    ".config/.git"
    ".config/Bitwarden"
    ".config/borg"
    ".config/chromium"
    ".config/Code"
    ".config/Electron"
    ".config/Element"
    ".config/FreeTube/Cache"
    ".config/fcitx"
    ".config/godot"
    ".config/libreoffice"
    ".config/obs-studio/logs"
    ".config/protonmail"
    ".config/REAPER"
    ".config/Slack"
    ".config/Sonixd"
    ".config/syncthing/*.db"
    ".config/unity3d"
    ".config/VSCodium"

    "share/p4acamera"
    "share/videos"
    "share/ytdl"

    "**/.cache"
    "**/*.dump"
    "**/*.log"
    "**/.terraform"
    "**/core.*"
    "**/Library"
    "**/node_modules"
    "**/target"
    "moby/moby.scm"
  ];

  common = {
    compression = "auto,zstd";
    encryption = {
      mode = "none";
    };
    exclude = map (s: home-path + "/" + s) exclude-home-paths;
    paths = home-path;
    prune = {
      keep = {
        hourly = 12;
        daily = 7;
        weekly = 3;
        monthly = 3;
      };
    };
    startAt = backupTime;
  };
in
{
  job = props: pkgs.lib.recursiveUpdate common props;
}
