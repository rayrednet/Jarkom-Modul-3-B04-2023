;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.B04.com. root.riegel.canyon.B04.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.B04.com.
@       IN      A       192.180.2.2 ; IP Eisen LB 
www     IN      CNAME   riegel.canyon.B04.com.