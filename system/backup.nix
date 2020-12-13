{ pkgs, ... }:
let
  home-path = "/home/ian";

  exclude-home-paths = [
    "downloads"
    "music"
    "tmp"
    "videos"
    "zotero"

    ".cache"
    ".cargo"
    ".compose-cache"
    ".debug"
    ".gnupg"
    ".mozilla"
    ".pki"
    ".rustup"
    ".ssh"
    ".zotero"

    ".config/.git"
    ".config/borg"
    ".config/chromium"
    ".config/Code"
    ".config/Element"
    ".config/fcitx"
    ".config/libreoffice"
    ".config/obs-studio/logs"

    ".local/share/Steam"
    ".local/share/TelegramDesktop"
    ".local/share/Trash"
    ".local/share/Zeal"

    "**/.cache"
    "**/.terraform"
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
        hourly = 3;
        daily = 7;
        weekly = 3;
        monthly = 3;
      };
    };
    startAt = "hourly";
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
    repo = "/tmp/homuraborg";
    user = "ian";
    doInit = false;
    preHook = ''
      mkdir -p /tmp/homuraborg
      /run/current-system/sw/bin/sshfs borg@homura:/share/MD0_DATA/nixborg /tmp/homuraborg
    '';
    postHook = ''
      /run/wrappers/bin/fusermount3 -u /tmp/homuraborg
    '';
    privateTmp = false;
    readWritePaths = [
      "/tmp"
    ];
  };
}
