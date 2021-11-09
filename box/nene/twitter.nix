{ pkgs, inputs, ... }:
let
  # inherit (inputs) filter-tweets;
  # filter-tweets = inputs.filter-tweets;
  filter-tweets = (import inputs.filter-tweets { inherit pkgs; }).package;
in
{
  systemd.services.twitter-filter-likes = {
    serviceConfig.Type = "oneshot";
    script = "${filter-tweets}/bin/likes";
  };
  systemd.timers.twitter-filter-likes = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-likes.service" ];
    timerConfig.OnCalendar = "*:10";
  };

  systemd.services.twitter-filter-rts = {
    serviceConfig.Type = "oneshot";
    script = "${filter-tweets}/bin/rts";
  };
  systemd.timers.twitter-filter-rts = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-rts.service" ];
    timerConfig.OnCalendar = "*:15";
  };

  systemd.services.twitter-filter-replies = {
    serviceConfig.Type = "oneshot";
    script = "${filter-tweets}/bin/replies";
  };
  systemd.timers.twitter-filter-replies = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-replies.service" ];
    timerConfig.OnCalendar = "*:20";
  };
}
