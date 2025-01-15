{ ... }:
{
  useDHCP = false;
  firewall.checkReversePath = "loose"; # for tailscale, test without
  extraHosts = ''
127.0.0.1     testlocal.ian.tokyo
192.168.0.102 anzu
192.168.0.117 ranni
192.168.0.119 pika
192.168.0.120 chaika
192.168.0.123 ema
192.168.0.127 fuuka
192.168.0.128 futaba
192.168.0.128 invid
192.168.0.128 freshrss
192.168.0.128 bin.ian.tokyo
192.168.0.128 git.ian.tokyo
192.168.0.128 todo.ian.tokyo
192.168.0.128 graham.tokyo
192.168.0.128 rainingmessages.dev
192.168.0.128 social.rainingmessages.dev
192.168.0.132 nene
192.168.0.133 rin
192.168.0.146 yuuri
192.168.0.151 makoto
192.168.0.156 mugi
192.168.0.167 bocchi
192.168.0.172 nano
192.168.0.219 mika
192.168.0.220 rika
'';
}
