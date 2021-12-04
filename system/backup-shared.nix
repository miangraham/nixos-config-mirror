{ pkgs, backupTime, ... }:
let
  home-path = "/home/ian";

  exclude-home-paths = [
    "downloads"
    "git"
    "mounts"
    "music"
    "nixpkgs"
    "tmp"
    "videos"
    "zotero"

    ".cabal"
    ".cache"
    ".cargo"
    ".compose-cache"
    ".debug"
    ".gnupg"
    ".mozilla"
    ".paradoxlauncher"
    ".pki"
    ".rustup"
    ".ssh"
    ".steam"
    ".vscode"
    ".zoom"
    ".zotero"

    ".config/.git"
    ".config/Bitwarden"
    ".config/borg"
    ".config/chromium"
    ".config/Code"
    ".config/Element"
    ".config/fcitx"
    ".config/libreoffice"
    ".config/obs-studio/logs"
    ".config/Slack"
    ".config/syncthing/*.db"
    ".config/VSCodium"

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
