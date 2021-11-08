# { ... }:
# let
#   unstable = import ./unstable.nix {};
# in
# (self: super: {
#   inherit (unstable)
#     sway
#     sway-contrib
#     swaylock
#     swayidle
#     xwayland
#     waybar
#     rofi
#     xdg-desktop-portal-wlr
#   ;
# })
