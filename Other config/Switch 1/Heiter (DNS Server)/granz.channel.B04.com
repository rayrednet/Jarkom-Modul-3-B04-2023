;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.B04.com. root.granz.channel.B04.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.B04.com.
@       IN      A       192.180.3.1 ; IP PHP worker
www     IN      CNAME   granz.channel.B04.com.