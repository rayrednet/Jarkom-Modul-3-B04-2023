service nginx start

mkdir -p /var/www/granz.channel.B04.com

cp granz.channel.B04.com /etc/nginx/sites-available/granz.channel.B04.com

ln -s /etc/nginx/sites-available/granz.channel.B04.com /etc/nginx/sites-enabled

service nginx restart