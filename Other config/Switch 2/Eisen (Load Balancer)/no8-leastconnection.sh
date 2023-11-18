service nginx start

cp lb-leastconnection /etc/nginx/sites-available/lb-granz

rm -f /etc/nginx/sites-enabled/lb-granz
ln -s /etc/nginx/sites-available/lb-granz /etc/nginx/sites-enabled/

service nginx restart