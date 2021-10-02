{ ... }:
let
  pkgs = import ../../common/stable.nix {};
  filter-tweets = import /home/ian/filter-tweets/default.nix { inherit pkgs; };
in
{
  # systemd.services.twitter-expire-favorites = {
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     ${pkgs.t}/bin/t favorites -l --profile=/home/ian/.trc \
  #     | ${pkgs.gawk}/bin/awk '{print $1}' \
  #     | xargs -r ${pkgs.t}/bin/t delete favorite --force --profile=/home/ian/.trc
  #   '';
  # };
  # systemd.timers.twitter-expire-favorites = {
  #   wantedBy = [ "timers.target" ];
  #   partOf = [ "twitter-expire-favorites.service" ];
  #   timerConfig.OnCalendar = "Sun 06:00";
  # };

  systemd.services.twitter-filter-likes = {
    serviceConfig.Type = "oneshot";
    script = "${filter-tweets.package}/bin/likes";
  };
  systemd.timers.twitter-filter-likes = {
    wantedBy = [ "timers.target" ];
    partOf = [ "twitter-filter-likes.service" ];
    timerConfig.OnCalendar = "Sun 06:00";
  };
}
