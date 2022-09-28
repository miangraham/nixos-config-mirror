{ pkgs, ... }:
let
  filter-tweets-src = pkgs.fetchFromSourcehut {
    owner = "~mian";
    repo = "filter-tweets";
    rev = "9d696646745aadd06d4ba854fc4d4b55b55797e8";
    sha256 = "sha256-Y2onVg/WMlKiBZES/vrzbtnbJA+lSLN7CVSWgMrpksY=";
  };
  filter-tweets = import filter-tweets-src { inherit pkgs; };
  serviceConfig = {
    Type = "oneshot";
    User = "ian";
    EnvironmentFile = /home/ian/.config/filter-tweets/env;
  };
in
{
  systemd.services.twitter-filter-likes = {
    inherit serviceConfig;
    script = "${filter-tweets}/bin/likes";
  };
  systemd.timers.twitter-filter-likes = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-likes.service" ];
    timerConfig.OnCalendar = "*:10";
  };

  systemd.services.twitter-filter-rts = {
    inherit serviceConfig;
    script = "${filter-tweets}/bin/rts";
  };
  systemd.timers.twitter-filter-rts = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-rts.service" ];
    timerConfig.OnCalendar = "*:15";
  };

  systemd.services.twitter-filter-replies = {
    inherit serviceConfig;
    script = "${filter-tweets}/bin/replies";
  };
  systemd.timers.twitter-filter-replies = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-replies.service" ];
    timerConfig.OnCalendar = "*:20";
  };
}
