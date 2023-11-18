service nginx start

mkdir -p /var/www/granz.channel.B04.com

cp granz.channel.B04.com /etc/nginx/sites-available/granz.channel.B04.com
rm /etc/nginx/sites-enabled/granz.channel.B04.com
ln -s /etc/nginx/sites-available/granz.channel.B04.com /etc/nginx/sites-enabled

apt-get update
apt-get install git -y
git -c http.sslVerify=false clone https://github.com/rayrednet/granz.channel.B04.com /var/www/granz.channel.B04.com

rm -rf /etc/nginx/sites-enabled/default

service php7.3-fpm start
service nginx restart