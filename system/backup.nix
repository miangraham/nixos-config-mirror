{ ... }:
{
  borgbackup.jobs.home-ian = {
    user = "ian";
    paths = "/home/ian";
    encryption.mode = "none";
    repo = "/run/media/ian/70F3-5B2F/home-ian";
    removableDevice = true;
    doInit = false;
    compression = "auto,zstd";
    startAt = "hourly";
    exclude = [
      "/home/ian/.cache"
      "/home/ian/.cargo"
      "/home/ian/.mozilla"
      "/home/ian/downloads"
      "/home/ian/music"
      "/home/ian/tmp"
      "/home/ian/videos"
      "/home/ian/.config/chromium"
      "/home/ian/.config/Code"
      "/home/ian/.config/Element"
      "/home/ian/.config/libreoffice"
      "/home/ian/**/target"
    ];
  };
}
