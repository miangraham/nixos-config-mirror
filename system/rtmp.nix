{ pkgs, ... }:
{
  src = pkgs.fetchFromGitHub {
    owner = "miangraham";
    repo = "nginx-rtmp-module";
    rev = "0b2ed1b31f393243e34fe87c2a531ed403a015b2";
    sha256 = "0gx0y90cl85pli849ywlwyav0yz6y2bv8gzsn7fci7yay0mxdwlv";
  };
}
