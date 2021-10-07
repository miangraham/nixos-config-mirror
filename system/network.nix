{ ... }:
{
  networking.useDHCP = false;
  networking.extraHosts = ''
127.0.0.1     testlocal.ian.tokyo
192.168.0.108 yuno
192.168.0.110 homura
192.168.0.111 nanachi
192.168.0.128 futaba
192.168.0.129 maho
192.168.0.132 nene
192.168.0.132 rss-bridge
192.168.0.133 rin
'';
}
