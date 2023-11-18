service nginx start

cp lb-laravel-leastconnection /etc/nginx/sites-available/lb-laravel

rm -f /etc/nginx/sites-enabled/lb-laravel
ln -s /etc/nginx/sites-available/lb-laravel /etc/nginx/sites-enabled/

service nginx restart