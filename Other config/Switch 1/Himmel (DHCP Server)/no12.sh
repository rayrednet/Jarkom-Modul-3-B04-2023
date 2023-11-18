cp 12-dhcpd.conf /etc/dhcp/dhcpd.conf
cp isc-dhcp-server /etc/default/isc-dhcp-server

service isc-dhcp-server restart
service isc-dhcp-server status