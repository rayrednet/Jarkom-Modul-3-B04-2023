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
'''
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
'''















