{ pkgs, backupTime, ... }:
let
  home-path = "/home/ian";

  exclude-home-paths = [
    "downloads"
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
    ".pki"
    ".rustup"
    ".ssh"
    ".vscode"
    ".zoom"
    ".zotero"

    ".config/.git"
    ".config/borg"
    ".config/chromium"
    ".config/Code"
    ".config/Element"
    ".config/fcitx"
    ".config/libreoffice"
    ".config/obs-studio/logs"
    ".config/Slack"
    ".config/syncthing/*.db"

    ".local/share/Steam"
    ".local/share/TelegramDesktop"
    ".local/share/Trash"
    ".local/share/Zeal"

    "share/p4acamera"
    "share/videos"

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

  job = props: pkgs.lib.recursiveUpdate common props;
in
{
  borgbackup.jobs.home-ian-to-local = job {
    repo = "/borg";
    user = "root";
    preHook = ''
      mkdir -p /borg
    '';
  };

  borgbackup.jobs.home-ian-to-usb = job {
    repo = "/run/media/ian/70F3-5B2F/borg";
    user = "ian";
    doInit = false;
    removableDevice = true;
  };

  borgbackup.jobs.home-ian-to-homura = job {
    repo = "/home/ian/mounts/homuraborg";
    user = "ian";
    doInit = false;
    preHook = ''
      mkdir -p /home/ian/mounts/homuraborg
      /run/current-system/sw/bin/sshfs borg@homura:/share/MD0_DATA/nixborg /home/ian/mounts/homuraborg
    '';
    postHook = ''
      /run/wrappers/bin/fusermount3 -u /home/ian/mounts/homuraborg
    '';
    extraArgs = "--lock-wait 30";
    environment = {
      BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
      BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
    };
  };
}
