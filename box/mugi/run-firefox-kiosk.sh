sleep 1
nmcli general reload
nmcli networking on
nmcli connection up 636512d0-0368-4713-8ca8-79b61e41f274
set +e
until host ian.tokyo; do sleep 1; done
set -e
swaymsg workspace number 2
swaymsg exec -- firefox -kiosk http://futaba:8091/lovelace/default_view
sleep 3
swaymsg fullscreen toggle
sleep 1
swaymsg fullscreen toggle
