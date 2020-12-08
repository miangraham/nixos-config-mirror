{ ... }:
let
  home-path = "/home/ian";

  exclude-home-paths = [
    ".cache"
    ".cargo"
    ".gnupg"
    ".local/share/Trash"
    ".local/share/Zeal"
    ".mozilla/firefox/**/storage"
    ".pki"
    ".rustup"
    ".ssh"
    "downloads"
    "music"
    "tmp"
    "videos"
    ".config/chromium"
    ".config/Code"
    ".config/Element"
    ".config/libreoffice"
    "**/.cache"
    "**/.terraform"
    "**/target"
    "**/*.dump"
  ];

  exclude = map (s: home-path + "/" + s) exclude-home-paths;

  prune = {
    keep = {
      hourly = 6;
      daily = 7;
      weekly = 3;
      monthly = 3;
    };
  };
  encryption = {
    mode = "none";
  };
  compression = "auto,zstd";
in
{
  borgbackup.jobs.home-ian-to-local = {
    repo = "/borg";
    user = "root";
    paths = home-path;
    startAt = "hourly";
    preHook = ''
      mkdir -p /borg
    '';

    inherit compression;
    inherit encryption;
    inherit exclude;
    inherit prune;
  };

  borgbackup.jobs.home-ian-to-usb = {
    repo = "/run/media/ian/70F3-5B2F/borg";
    user = "ian";
    paths = home-path;
    startAt = "hourly";
    doInit = false;
    removableDevice = true;

    inherit compression;
    inherit encryption;
    inherit exclude;
    inherit prune;
  };

  borgbackup.jobs.home-ian-to-homura = {
    repo = "/tmp/homuraborg";
    user = "ian";
    paths = home-path;
    startAt = "hourly";
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

    inherit compression;
    inherit encryption;
    inherit exclude;
    inherit prune;
  };
}
