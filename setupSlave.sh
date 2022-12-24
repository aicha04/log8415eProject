#!/bin/bash
echo "setting up slave" >> /var/log/user-data.log
sudo apt-get update
sudo apt-get install -y wget
cd ~
echo "downloading my sql cluster data node binary" >> /var/log/user-data.log
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-data-node_8.0.31-1ubuntu22.04_amd64.deb
echo "installing dependencies" >> /var/log/user-data.log

sudo apt-get update
sudo apt-get install libclass-methodmaker-perl
sudo dpkg -i mysql-cluster-community-data-node_8.0.31-1ubuntu22.04_amd64.deb
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/my.cnf > /etc/my.cnf

echo "creating data directory" >> /var/log/user-data.log
sudo mkdir -p /usr/local/mysql/data
echo "starting data node" >> /var/log/user-data.log
sudo ndbd >> /var/log/user-data.log
echo "setting cluster so it starts on boot" >> /var/log/user-data.log
sudo pkill -f ndbd
sudo nano /etc/systemd/system/ndbd.service
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/ndbd.service > /etc/systemd/system/ndbd.service
echo "reloading deamon" >> /var/log/user-data.log
sudo systemctl daemon-reload
echo "starting service" >> /var/log/user-data.log
sudo systemctl enable ndbd
sudo systemctl start ndbd
sudo systemctl status ndbd >> /var/log/user-data.log
echo "set up ended" >> /var/log/user-data.log
