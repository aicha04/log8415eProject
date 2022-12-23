#!/bin/bash
# installing MySQL server
echo "Instralling MySQL" >> /var/log/user-data.log
sudo apt-get update
sudo apt-get install -y mysql-server 
echo "setting up MySQL" >> /var/log/user-data.log
echo "Instralling sakila database" >> /var/log/user-data.log

sudo apt-get update
sudo apt-get install -y wget
echo "downloading sakila database" >> /var/log/user-data.log

sudo wget https://downloads.mysql.com/docs/sakila-db.tar.gz && sudo tar -xf sakila-db.tar.gz -C /tmp/
echo "running mysql as root" >> /var/log/user-data.log

sudo mysql -u root -e  "SOURCE /tmp/sakila-db/sakila-schema.sql; SOURCE /tmp/sakila-db/sakila-data.sql; USE sakila; create user user identified by 'password'; ">>/var/log/user-data.log
sudo mysql -u root -e "USE sakila; grant all on sakila.* to `user`@`%`;show grants for user;"
echo "server set up" >> /var/log/user-data.log

#sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i 's/127.0.0.1/0.0.0.0/1' /etc/mysql/mysql.conf.d/mysqld.cnf
#sudo systemctl restart mysql