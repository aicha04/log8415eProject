#!/bin/bash
echo "setting up master" >> /var/log/user-data.log
sudo apt-get update
sudo apt-get install -y wget
cd /home/ubuntu
echo "downloading my sql cluster management server" >> /var/log/user-data.log
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-management-server_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_8.0.31-1ubuntu22.04_amd64.deb
echo "setting config.ini file" >> /var/log/user-data.log
sudo mkdir /var/lib/mysql-cluster
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/config.ini > /var/lib/mysql-cluster/config.ini
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
echo "setting cluster so it starts on boot" >> /var/log/user-data.log
sudo pkill -f ndb_mgmd
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/ndb_mgmd.service > /etc/systemd/system/ndb_mgmd.service

echo "reloading daemon" >> /var/log/user-data.log
sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
echo "start service" >> /var/log/user-data.log
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd >> /var/log/user-data.log
echo "setting mysql server and Client" >> /var/log/user-data.log
cd /home/ubuntu
echo "downloading mysql cluster and Client" >> /var/log/user-data.log
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster_8.0.31-1ubuntu22.04_amd64.deb-bundle.tar
sudo mkdir /home/ubuntu/install
sudo tar -xvf mysql-cluster_8.0.31-1ubuntu22.04_amd64.deb-bundle.tar -C install/
cd install
sudo apt-get update
sudo apt-get install -y libaio1 libmecab2
sudo dpkg -i mysql-common_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client-plugins_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client-core_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-client_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server-core_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-server_8.0.31-1ubuntu22.04_amd64.deb
echo "configuring my.cnf file" >> /var/log/user-data.log
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/mastermy.cnf >> /etc/mysql/my.cnf
echo "restarting mysql server" >> /var/log/user-data.log
sudo systemctl restart mysql
echo "setup ended" >> /var/log/user-data.log
