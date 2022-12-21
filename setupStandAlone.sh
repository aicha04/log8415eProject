# installing MySQL server
echo "Instralling MySQL" >> /var/log/user-data.log
apt-get update
apt-get install -y mysql-server 
echo "setting up MySQL" >> /var/log/user-data.log
mysql_secure_installation
echo "Instralling sakila database" >> /var/log/user-data.log
apt-get update
apt-get install-y wget
wget https://downloads.mysql.com/docs/sakila-db.tar.gz && tar -xf sakila-db.tar.gz -C /tmp/
mysql -u root -p
SOURCE /tmp/sakila-db/sakila-schema.sql;
SOURCE /tmp/sakila-db/sakila-data.sql;
USE sakila; >> /var/log/user-data.log
SHOW FULL TABLES; >> /var/log/user-data.log

echo "server set up" >> /var/log/user-data.log