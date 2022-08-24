{ pkgs, inputs, ... }:
let
  # inherit (inputs) filter-tweets;
  # filter-tweets = inputs.filter-tweets;
  filter-tweets = import inputs.filter-tweets { inherit pkgs; };
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
