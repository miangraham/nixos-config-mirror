{ ... }:
{
  networking.useDHCP = false;
  networking.firewall.checkReversePath = "loose"; # for tailscale
  networking.extraHosts = ''
127.0.0.1     testlocal.ian.tokyo
192.168.0.108 yuno
192.168.0.110 homura
192.168.0.111 nanachi
192.168.0.117 ranni
192.168.0.119 pika
192.168.0.120 boxypi
192.168.0.127 fuuka
192.168.0.127 nextcloud
192.168.0.128 futaba
192.168.0.128 invid
192.168.0.128 freshrss
192.168.0.128 graham.tokyo
192.168.0.129 maho
192.168.0.132 nene
192.168.0.133 rin
192.168.0.155 tinypi
192.168.0.167 bocchi
'';
}
