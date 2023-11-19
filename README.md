# Laporan Resmi Praktikum Jaringan Komputer Modul 3 - DHCP & Reverse Proxy

## Identitas Kelompok
| Nama                                 | NRP        |
| -------------------------------------|------------|
| Rayssa Ravelia                       | 5025211219 |
| Immanuel Pascanov Samosir            | 5025211257 |

## Konfigurasi awal
1.  Pertama kita harus membuat image docker baru dari: danielcristh0/debian-buster:1.1, Berikut langkah-langkahnya :

a. Pilih go to preferences  
  <img width="465" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/32db2e80-f87c-4285-aad0-a067de54914c">

b. Pilih docker

  <img width="464" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/8a3fb943-7caf-4dae-ae5e-b5576403712b">

c. Pilih add docker container template

  <img width="415" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/49b475a4-2c97-4e99-bb33-2d9239928fec">

d. Pilih server type: Run this Docker container locally

  <img width="443" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/b4051f3c-1591-405c-a82d-d13d1456ae0b">

  e. Pilih Docker Virtual Machine: New Image, dan masukkan image danielcristh0/debian-buster:1.1

  <img width="438" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/342b019b-0a5b-422d-8e9e-6579a857cfec">

  f. Isi container name: debian

  <img width="310" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/b7ef8a48-3dbc-4501-90a2-bc1f1b952a25">

  g. Pilih network adapters sebanyak 5, sebab di topologi bagian router (Aura) memiliki 5 kaki

  <img width="305" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/7d868243-1c5e-4fd1-bcf4-ab3ae85258a6">

 h. Pilih Add template

  <img width="309" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/66829a15-969b-40ed-a403-520da97efc49">

2. Kedua, buat topologi sesuai dengan soal sebagai berikut :
   
   <img width="294" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/ceb2bae8-a90f-45eb-a2f5-8120ecdb2030">

     Tahapan:

   a. Buat node secara garis besarnya sebagai berikut
   
     <img width="245" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/7830b803-f43a-4ed4-909f-c5070120ecaa">

   b. Ubah icon node sesuai dengan topologi pada soal

     <img width="256" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/c081e3c0-b949-416a-9db6-0cb4d08f238b">

   c. Ubah nama node sesuai dengan soal

     <img width="261" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/25513334-7910-4011-8b31-c19e5c7da01d">

   d. Hubungkan node ke node lain sesuai dengan topologi soal

     <img width="278" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/30767f12-3a42-46bc-b041-44699ba802af">

   e. Selanjutnya, atur konfigurasi IP address sesuai dengan tabel

  | Node             | Kategori         | Image Docker                | Konfigurasi IP | 
  |------------------|------------------|-----------------------------|----------------| 
  | Aura             | Router (DHCP Relay) | danielcristh0/debian-buster:1.1 | Dynamic    | 
  | Himmel           | DHCP Server      | danielcristh0/debian-buster:1.1 | Static         | 
  | Heiter           | DNS Server       | danielcristh0/debian-buster:1.1 | Static         | 
  | Denken           | Database Server  | danielcristh0/debian-buster:1.1 | Static         | 
  | Eisen            | Load Balancer    | danielcristh0/debian-buster:1.1 | Static         | 
  | Frieren          | Laravel Worker   | danielcristh0/debian-buster:1.1 | Static         | 
  | Flamme           | Laravel Worker   | danielcristh0/debian-buster:1.1 | Static         | 
  | Fern             | Laravel Worker   | danielcristh0/debian-buster:1.1 | Static         | 
  | Lawine           | PHP Worker       | danielcristh0/debian-buster:1.1 | Static         | 
  | Linie            | PHP Worker       | danielcristh0/debian-buster:1.1 | Static         | 
  | Lugner           | PHP Worker       | danielcristh0/debian-buster:1.1 | Static         | 
  | Revolte          | Client           | danielcristh0/debian-buster:1.1 | Dynamic        | 
  | Richter          | Client           | danielcristh0/debian-buster:1.1 | Dynamic        | 
  | Sein             | Client           | danielcristh0/debian-buster:1.1 | Dynamic        | 
  | Stark            | Client           | danielcristh0/debian-buster:1.1 | Dynamic        |

## Aura (DHCP Relay)
```plaintext
	# DHCP config for eth0
		auto eth0
		iface eth0 inet dhcp
			up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 198.180.0.0/16

		# Static config for eth1
		auto eth1
		iface eth1 inet static
			address 198.180.1.100
			netmask 255.255.255.0

		# Static config for eth2
		auto eth2
		iface eth2 inet static
			address 198.180.2.100
			netmask 255.255.255.0

		# Static config for eth3
		auto eth3
		iface eth3 inet static
			address 198.180.3.100
			netmask 255.255.255.0

		# Static config for eth4
		auto eth4
		iface eth4 inet static
			address 198.180.4.100
			netmask 255.255.255.0

Switch 1
Himmel (DHCP Server)
		auto eth0
		iface eth0 inet static
			address 198.180.1.1
			netmask 255.255.255.0
			gateway 198.180.1.100

Heiter (DNS Server)
		auto eth0
		iface eth0 inet static
			address 198.180.1.2
			netmask 255.255.255.0
			gateway 198.180.1.100
   
Switch 2
Denken (Database Server)
	auto eth0
	iface eth0 inet static
		address 198.180.2.1
		netmask 255.255.255.0
		gateway 198.180.2.100

Eisen (Load Balancer)
	auto eth0
	iface eth0 inet static
		address 198.180.2.2
		netmask 255.255.255.0
		gateway 198.180.2.100

Switch 3
Revolte (client)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether 82:d3:e5:06:fb:2c

Richter (client)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether 96:05:97:2a:29:65

Lawine (PHP worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether 3a:ff:68:ce:d5:cf

Linie (PHP worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether 76:a0:85:61:16:3e

Lugner (PHP worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether 1e:9d:8e:94:86:46

Switch 4
Sein (client)
	auto eth0
	iface eth0 inet dhcp

Stark (client)
	auto eth0
	iface eth0 inet dhcp

Frieren (Laravel worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether be:6a:9c:c4:ae:30

Flamme (Laravel worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether c6:30:18:d2:fd:9a

Fern (Laravel worker)
	auto eth0
	iface eth0 inet dhcp
	hwaddress ether a2:e5:59:6d:aa:80
```
## Topologi dengan IP address yang telah ditentukan :

<img width="305" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/b3066f52-376b-4561-ad78-b29d9517c563">

```plaintext
Pada Aura (Router), angka terakhir oktet pada IP address tidak dapat .0 (menandakan network itu sendiri) dan .255 (untuk broadcast address) karena oktet tersebut reserved. Maka dari itu saya memilih oktet terakhir .100 dengan juga mempertimbangkan:
- Pada soal harus terdapat worker yang memiliki IP oktet terakhir .1
“ Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker PHP dan granz.channel.yyy.com untuk worker Laravel (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.”
- IP oktet terakhir harus berada di luar range dari IP Client yang bersifat dynamic dengan range:
- Melalui switch 3: 192.180.3.16 - 192.180.3.32 dan 192.180.3.64 - 192.180.3.80
- Melalui switch 4: 192.180.4.12 - 192.180.4.20 dan 192.180.4.160 - 192.180.4.168
Berdasarkan ketentuan soal tersebut, angka untuk oktet 100 memenuhi syarat agar router dapat berjalan dengan baik. Pada node lainnya (Himmel, Heiter, Denken, Eisen, Frieren, Flamme, Fern, Lawine, Linie, dan Lugner), mereka memiliki IP dengan subnet mask 255.255.255.0, dan gateway setiap node berkorelasi dengan interface IP address Aura (router) di subnet.
```

## Konfigurasi /root/.bashrc setiap node

```plaintext
Aura (DHCP Relay)
	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.180.0.0/16
	apt-get update
	apt-get install isc-dhcp-server
	apt-get install isc-dhcp-relay -y
	service isc-dhcp-relay start

Switch 1
	Himmel (DHCP Server)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install isc-dhcp-server
		apt-get install dnsutils

	Heiter (DNS Server)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update && apt-get install bind9 -y

Switch 2
	Denken (Database Server)
		echo nameserver 192.180.1.2 > /etc/resolv.conf
		apt-get update
		apt-get install mariadb-server -y
		service mysql start

	Eisen (Load Balancer)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install apache2-utils -y
		apt-get install nginx -y
		apt-get install lynx -y
		service nginx start

Switch 3
	Revolte (client)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install lynx
		apt-get install apache2-utils
		apt-get install htop

	Richter (client)
		apt-get update
		apt-get install lynx
		apt-get install apache2-utils
		apt-get install htop

	Lawine (PHP worker)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install nginx -y
		apt-get install php7.3
		apt-get install php7.3-fpm
		apt-get install libapache2-mod-php7.3
		apt-get install htop
		service nginx start
		systemctl enable php7.3-fpm
		service php7.3-fpm start
		php -v

	Linie (PHP worker)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install nginx -y
		apt-get install php7.3
		apt-get install php7.3-fpm
		apt-get install libapache2-mod-php7.3
		apt-get install htop
		service nginx start
		systemctl enable php7.3-fpm
		service php7.3-fpm start
		php -v

	Lugner (PHP worker)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install nginx -y
		apt-get install php7.3
		apt-get install php7.3-fpm
		apt-get install libapache2-mod-php7.3
		apt-get install htop
		service nginx start
		systemctl enable php7.3-fpm
		service php7.3-fpm start
		php -v

Switch 4
	Sein (client)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install lynx
		apt install htop -y
		apt install apache2-utils -y
		apt-get install jq -y

	Stark (client)
		echo nameserver 192.168.122.1 > /etc/resolv.conf
		apt-get update
		apt-get install lynx
		apt install htop -y
		apt install apache2-utils -y
		apt-get install jq -y

	Frieren (Laravel worker)
		apt-get update
		apt-get install htop

	Flamme (Laravel worker)
		apt-get update
		apt-get install htop

	Fern (Laravel worker)
		apt-get update
		apt-get install htop
```

## Daftar Isi
[Nomor 1](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-1) <br/>
[Nomor 2](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-2) <br/>
[Nomor 3](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-3) <br/>
[Nomor 4](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-4) <br/>
[Nomor 5](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-5) <br/>
[Nomor 6](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-6) <br/>
[Nomor 7](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-7) <br/>
[Nomor 8](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-8) <br/>
[Nomor 9](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-9) <br/>
[Nomor 10](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-10) <br/>
[Nomor 11](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-11) <br/>
[Nomor 12](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-12) <br/>
[Nomor 13](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-13) <br/>
[Nomor 14](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-14) <br/>
[Nomor 15](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-15) <br/>
[Nomor 16](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-16) <br/>
[Nomor 17](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-17) <br/>
[Nomor 18](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-18) <br/>
[Nomor 19](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-19) <br/>
[Nomor 20](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/#-nomor-20) <br/>

### ⭐ Nomor 1
### Soal
Lakukan konfigurasi sesuai dengan peta yang sudah diberikan. Setelah mengalahkan Demon King, perjalanan berlanjut. Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.B04.com untuk worker Laravel dan granz.channel.B04.com untuk worker PHP mengarah pada worker yang memiliki IP 192.180.x.1

### Jawaban
Pada soal kita diminta untuk register domain riegel.canyon.B04.com untuk worker Laravel dan granz.channel.B04.com untuk worker PHP yang mengarah ke worker dengan IP 192.180.x.1. Pada topologi yang dibuat, worker yang memiliki IP okter terakhir .1 adalah Lawine (PHP Worker: 192.180.3.1) dan Frieren (Laravel worker: 192.180.4.1). 

Untuk melakukan perintah soal, kita harus melakukan konfigurasi pada DNS Server (Heiter) sebagai berikut (no0.sh):
```
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
@               IN      A       192.180.3.1       ; IP worker PHP di switch 3
www             IN      CNAME   granz.channel.B04.com.
' > /etc/bind/granz/granz.channel.B04.com


echo '
zone "riegel.canyon.B04.com" {
    type master;
    file "/etc/bind/riegel/riegel.canyon.B04.com";
};' >> /etc/bind/named.conf.local


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
@               IN      A       192.180.4.1       ; IP worker Laravel di switch 4
www             IN      CNAME   riegel.canyon.B04.com.
' >  /etc/bind/riegel/riegel.canyon.B04.com


service bind9 restart
```

Selanjutnya lakukan hal ini di himmel (configDHCPserver.sh) :
```
cp dhcpd.conf /etc/dhcp/dhcpd.conf
cp isc-dhcp-server /etc/default/isc-dhcp-server


service isc-dhcp-server restart
service isc-dhcp-server status
```

Kemudian jalankan ini di dalam aura (configDHCPrelay.sh)
```
cp sysctl.conf /etc/sysctl.conf
cp isc-dhcp-relay /etc/default/isc-dhcp-relay
service isc-dhcp-relay restart
```
### Testing
Untuk mengujinya kami melakukan testing di client Richter dengan menjalankan 2 perintah berikut:
```
ping riegel.canyon.b04.com
```
![1 1](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/bde011cd-86b6-4394-9e79-7e980119fd70)
```
ping granz.channel.b04.com
```
![1 2](https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/f30f36ac-103c-4e02-9438-fa4dea775b14)

<img width="311" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/2762efc5-47b0-4b74-90ca-de31d89a06e5">

### ⭐ Nomor 2
### Soal
Client yang melalui Switch3 mendapatkan range IP dari 192.180.3.16 - 192.180.3.32 dan 192.180.3.64 - 192.180.3.80

### Jawaban
Lakukan konfigurasi pada DHCP Server (Himmel) :
```
echo 'subnet 192.180.1.0 netmask 255.255.255.0 {
}

subnet 192.180.2.0 netmask 255.255.255.0 {
}

subnet 192.180.3.0 netmask 255.255.255.0 {
    range 192.180.3.16 192.180.3.32;
    range 192.180.3.64 192.180.3.80;
    option routers 192.180.3.0;
}' > /etc/dhcp/dhcpd.con
```
### Testing
Berikut ini adalah IP yang diperoleh ketika client di switch3 dibuka :
a. Revolte
<img width="310" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/7ae0d1c9-3a51-454e-9cb7-e35ce2d6681c">

b. Richter
<img width="304" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/83875c6d-e7cd-4239-9dc0-9553541a0840">

### ⭐ Nomor 3
### Soal
Client yang melalui Switch4 mendapatkan range IP dari 192.180.4.12 - 192.180.4.20 dan 192.180.4.160 - 192.180.4.168

### Jawaban
Lakukan konfigurasi pada DHCP Server (Himmel) :
```
echo 'subnet 192.180.1.0 netmask 255.255.255.0 {
}

subnet 192.180.2.0 netmask 255.255.255.0 {
}

subnet 192.180.3.0 netmask 255.255.255.0 {
    range 192.180.3.16 192.180.3.32;
    range 192.180.3.64 192.180.3.80;
    option routers 192.180.3.0;
}

subnet 192.180.4.0 netmask 255.255.255.0 {
    range 192.180.4.12 192.180.4.20;
    range 192.180.4.160 192.180.4.168;
    option routers 192.180.4.0;
} ' > /etc/dhcp/dhcpd.conf
```
### Testing
Berikut ini adalah IP yang diperoleh ketika client di switch 4 dibuka :
a. Sein
<img width="309" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/48140d52-974f-4a88-80b1-f2042e16fa1a">

b. Stark
<img width="309" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/fb6a4d58-cd60-46d5-b98f-7dfeab2cecc6">

### ⭐ Nomor 4
### Soal
Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut

### Jawaban
Agar dapat terhubung ke DNS kita harus menambahkan konfigurasi berikut:
```
subnet 192.180.3.0 netmask 255.255.255.0 {
    ...
    option broadcast-address 192.180.3.255;
    option domain-name-servers 192.180.1.2;
    ...
}

subnet 192.180.4.0 netmask 255.255.255.0 {
    option broadcast-address 192.180.4.255;
    option domain-name-servers 192.180.1.2;
}
```

Jalankan bash script berikut di dalam DHCP Server (Himmel)

```
echo 'subnet 192.180.1.0 netmask 255.255.255.0 {
}

subnet 192.180.2.0 netmask 255.255.255.0 {
}

subnet 192.180.3.0 netmask 255.255.255.0 {
    range 192.180.3.16 192.180.3.32;
    range 192.180.3.64 192.180.3.80;
    option routers 192.180.3.0;
    option broadcast-address 192.180.3.255;
    option domain-name-servers 192.180.1.2;
}

subnet 192.180.4.0 netmask 255.255.255.0 {
    range 192.180.4.12 192.180.4.20;
    range 192.180.4.160 192.180.4.168;
    option routers 192.180.4.0;
    option broadcast-address 192.180.4.255;
    option domain-name-servers 192.180.1.2;
} ' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server start
```

Kemudian, jalankan command ini di dalam DHCP Relay (Aura)

```
echo '# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="192.180.1.1"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3 eth4"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""' > /etc/default/isc-dhcp-relay

service isc-dhcp-relay start
```
Selanjutnya, pada file /etc/sysctl.conf lakukan uncomment pada net.ipv4.ip_forward=1
<img width="310" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/089c7078-9519-4ed9-b76a-05dfd371a05b">

### Testing
Untuk melakukan testing, kami mencoba melakukan ping dari client Stark
```
ping riegel.canyon.b04.com
```
<img width="311" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/75cb3d26-61d9-43b8-850f-6bfec0a229a5">

```
ping granz.channel.b04.com 
```
<img width="312" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/ca2cc021-a208-412c-abc2-e24e5c61eed8">

### ⭐ Nomor 5
### Soal
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit

### Jawaban
Peminjaman melalui switch 3 selama 3 menit = 180s dan peminjaman melalui switch4 selama 12 menit = 720s

### Testing
Berikut ini adalah hasil testing untuk lease time pada switch 3 dan switch 4:
a. Switch 3 (Richter)
<img width="304" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/97201521-07a8-4524-b219-4db50701ad0e">

b. Switch 4 (Sein)
<img width="311" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/9828b62c-908b-4ca6-98d9-c24ea69488ef">

Untuk menjawab soal nomor 1-5, kami gabungkan menjadi sebagai berikut:
a. Masuk ke node heiter, himmel, dan aura

b. Masuk ke node heiter dan lakukan bash no0.sh

<img width="309" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/b764ff73-d953-4c04-a184-dede73171b1a">

c. Masuk ke node himmel dan lakukan bash configDHCPserver.sh
<img width="270" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/fd2ee9a9-9a48-4be8-b42e-2dab6e108d4c">

d. Masuk ke node aura dan lakukan bash configDHCPrelay
<img width="215" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/4f781e75-7caf-44c4-b61c-92bd23f52042">

e. Restart semua node worker (PHP dan Laravel) dan client

<img width="281" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/69b52d74-9807-432c-9f40-ec5a3ebc9cd7">

<img width="279" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/f349ef52-c709-4dce-affb-f9e4f087a389">

f. Jalankan perintah sesuai dengan testing untuk nomor 1-5

### ⭐ Nomor 6
### Soal
Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3

### Jawaban
Jalankan no6.sh di Lawine, Linie, Lugner

### Testing
Masukkan lynx 192.180.3.1, lynx 192.180.3.2, lynx 192.180.3.3 pada client di switch 3. Sebagai contoh kami menjalankan di Revolte sebagai berikut :
a. Lawine (lynx 192.180.3.1)
<img width="290" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/bf52689d-b3fa-459e-b823-76452c74dcab">

<img width="283" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/3449f03d-c7e2-486a-8d07-263d22528404">

b. Linie (lynx 192.180.3.2)
<img width="285" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/bc160189-a3e6-466c-b19a-3717d4795a8a">

<img width="283" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/2a825f74-2ecf-4b35-b23d-4483130701f3">

c. Lugner (lynx 192.180.3.3)
<img width="284" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/0eea7cde-a7fe-4feb-8006-4ca193f44ab3">

<img width="288" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/3c2677dd-fbb5-4afc-bd58-ad8720845a0b">

### ⭐ Nomor 7
### Soal
Kepala suku dari Bredt Region memberikan resource server sebagai berikut:
```
	a. Lawine, 4GB, 2vCPU, dan 80 GB SSD.
	b. Linie, 2GB, 2vCPU, dan 50 GB SSD.
	c. Lugner 1GB, 1vCPU, dan 25 GB SSD.
```
aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second!

### Jawaban
Tahapan pengerjaan:
a. Masuk ke node Heiter dan bash no7.sh
<img width="309" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/f4f960f0-896f-4eb0-8acf-eb858f19d0a7">

b. Masuk ke node eisen, lakukan bash no8-roundrobin.sh
<img width="165" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/07293372-1234-4103-bfba-4e51d74f89c8">

### Testing 
Sebagai contoh lakukan testing di Revolte, jalankan perintah ab -n 1000 -c 100 http://www.granz.channel.B04.com/
<img width="311" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/a898f927-d7a7-4680-a4cf-29caaa3f0201">

;
<img width="308" alt="image" src="https://github.com/rayrednet/Jarkom-Modul-3-B04-2023/assets/89269231/cf0209b0-e980-4c25-8501-d1d2168f189b">

### ⭐ Nomor 8
### Soal
Karena diminta untuk menuliskan grimoire, buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:
```
a. Nama Algoritma Load Balancer
b. Report hasil testing pada Apache Benchmark
c. Grafik request per second untuk masing masing algoritma. 
d. Analisis
```

### Jawaban
Tahapan pengerjaan:
a. Masuk ke node eisen, lakukan bash no8-roundrobin.sh



### Testing
a. Masuk ke client Revolte dan lakukan ab -n 200 -c 10 http://www.granz.channel.B04.com/
b. Masukkan htop di setiap worker PHP
- Lawine
- Linie
- Lugner


### ⭐ Nomor 9
### Soal
Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire.

### Jawaban

Langkah pengerjaan:
a. Masuk ke node eisen, jalankan bash no8-roundrobin.sh
b.

### Testing
#### 3 worker
a. Masuk ke client Revolte jalankan ab -n 100 -c 10 http://www.granz.channel.B04.com/
b. htop pada Lugner
c. htop pada Linie
d. htop pada Lawine

#### 2 worker
Matikan salah satu worker dari ketiga worker, sebagai contoh Lugner jalankan service nginx stop


Sehingga worker yang berjalan hanya Lawine dan Linie

Selanjutnya masuk ke client Revolte jalankan ab -n 100 -c 10 http://www.granz.channel.B04.com/

a. Htop pada Lawine

b. Htop pada Linie

#### 1 worker
Matikan 1 worker lagi, sebagai contoh Linie. Sehingga worker yang hidup hanya Lawine

Selanjutnya masuk ke client Revolte jalankan ab -n 100 -c 10 http://www.granz.channel.B04.com/

a. Htop pada Lawine

### ⭐ Nomor 10
### Soal
Selanjutnya coba tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/

### Jawaban

### ⭐ Nomor 11
### Soal
Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id

### Jawaban

### ⭐ Nomor 12
### Soal
Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].3.69, [Prefix IP].3.70, [Prefix IP].4.167, dan [Prefix IP].4.168.

### Jawaban

### ⭐ Nomor 13
### Soal
Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern.

### Jawaban

### ⭐ Nomor 14
### Soal
Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer

### Jawaban

### ⭐ Nomor 15
### Soal
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire POST /auth/register

### Jawaban

### ⭐ Nomor 16
### Soal
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire POST /auth/login

### Jawaban

### ⭐ Nomor 17
### Soal
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire GET /me

### Jawaban

### ⭐ Nomor 18
### Soal
Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka implementasikan Proxy Bind pada Eisen untuk mengaitkan IP dari Frieren, Flamme, dan Fern.

### Jawaban

### ⭐ Nomor 19
### Soal
Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada Grimoire.

### Jawaban

### ⭐ Nomor 20
### Soal
Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second.

### Jawaban
























 

 

