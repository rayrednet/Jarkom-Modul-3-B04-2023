#!bin/bash

cp named.conf.options /etc/bind/named.conf.options

echo '
zone "granz.channel.B04.com" {
    type master;
    file "/etc/bind/granz/granz.channel.B04.com";
};' >> /etc/bind/named.conf.local

mkdir -p /etc/bind/granz

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     channel.B04.com. root.channel.B04.com. (
                        2023131101      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      granz.channel.B04.com.
@               IN      A       192.180.3.1       ; IP PHP worker
www             IN      CNAME   granz.channel.B04.com.
' > /etc/bind/granz/granz.channel.B04.com

echo '
zone "riegel.canyon.B04.com" {
    type master;
    file "/etc/bind/riegel/riegel.canyon.B04.com";
};' >> /etc/bind/named.conf.local

mkdir -p /etc/bind/riegel
cp riegel.canyon.B04.com /etc/bind/riegel/riegel.canyon.B04.com

service bind9 restart