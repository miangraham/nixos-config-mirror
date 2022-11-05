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

    ".cabal"
    ".cache"
    ".cargo"
    ".compose-cache"
    ".debug"
    ".gnupg"
    ".m2"
    ".mozilla"
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
    "core.*"

    ".config/.git"
    ".config/Bitwarden"
    ".config/borg"
    ".config/chromium"
    ".config/Code"
    ".config/Element"
    ".config/FreeTube/Cache"
    ".config/fcitx"
    ".config/godot"
    ".config/libreoffice"
    ".config/obs-studio/logs"
    ".config/protonmail"
    ".config/Slack"
    ".config/Sonixd"
    ".config/syncthing/*.db"
    ".config/VSCodium"

    ".emacs.d/eln-cache"

    ".local/share"

    "share/p4acamera"
    "share/videos"
    "share/ytdl"

    "**/.cache"
    "**/.terraform"
    "**/node_modules"
    "**/target"
    "**/*.dump"
    "**/*.log"
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
