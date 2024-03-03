{ config, pkgs, inputs, ... }:
let
  blocky = import ../futaba/blocky.nix { inherit pkgs; };
in
{
  services = {
    inherit blocky;
  };
}
