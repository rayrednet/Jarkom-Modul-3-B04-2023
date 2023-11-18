#!bin/bash

mkdir -p /etc/bind/riegel
echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     canyon.B04.com. root.canyon.B04.com. (
                        2023131101      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      riegel.canyon.B04.com.
@               IN      A       192.180.2.2       ; IP Eisen Load Balancer
www             IN      CNAME   riegel.canyon.B04.com.
' >  /etc/bind/riegel/riegel.canyon.B04.com

service bind9 restart