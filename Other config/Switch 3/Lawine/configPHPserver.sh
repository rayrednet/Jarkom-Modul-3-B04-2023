rm -r /var/www/granz.channel.B04

service apache2 start

cp granz.channel.B04.com.conf /etc/apache2/sites-available/granz.channel.B04.com.conf
cp ports.conf /etc/apache2/ports.conf

a2ensite granz.channel.B04.com.conf

service apache2 reload
service apache2 restart

mkdir -p /var/www/granz.channel.B04
apt-get update
apt-get install git -y
git -c http.sslVerify=false clone https://github.com/rayrednet/granz.channel.B04.com /var/www/granz.channel.B04

service apache2 reload
service apache2 restart