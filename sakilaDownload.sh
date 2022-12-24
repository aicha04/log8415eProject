#!/bin/bash
# curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/sakilaDownload.sh > sakilaDownload.sh && bash sakilaDownload.sh

echo "Instralling sakila database" >> /var/log/user-data.log

sudo apt-get update
sudo apt-get install -y wget
echo "downloading sakila database" >> /var/log/user-data.log

sudo wget https://downloads.mysql.com/docs/sakila-db.tar.gz && sudo tar -xf sakila-db.tar.gz -C /tmp/
echo "running mysql as root" >> /var/log/user-data.log

sudo mysql -u root -e  "SOURCE /tmp/sakila-db/sakila-schema.sql; SOURCE /tmp/sakila-db/sakila-data.sql; USE sakila; create user user identified by 'password'; ">>/var/log/user-data.log
sudo mysql -u root -e 'USE sakila; grant all on sakila.* to `user`@`%`;show grants for user;'
