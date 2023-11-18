cp 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
cp my.cnf /etc/mysql/my.cnf

service mysql restart

#!/bin/bash

# Prompt for the MySQL root password
read -sp 'Enter MySQL root password: ' MYSQL_ROOT_PASSWORD
echo

# Execute MySQL commands
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
DROP USER IF EXISTS 'kelompokB04'@'%';
DROP USER IF EXISTS 'kelompokB04'@'localhost';
CREATE USER 'kelompokB04'@'%' IDENTIFIED BY 'passwordB04';
CREATE USER 'kelompokB04'@'localhost' IDENTIFIED BY 'passwordB04';
DROP DATABASE IF EXISTS dbkelompokB04;
CREATE DATABASE dbkelompokB04;
GRANT ALL PRIVILEGES ON dbkelompokB04.* TO 'kelompokB04'@'%';
GRANT ALL PRIVILEGES ON dbkelompokB04.* TO 'kelompokB04'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "dbkelompokB04 created"