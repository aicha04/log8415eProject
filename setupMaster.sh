#!/bin/bash
sudo apt-get update
sudo apt-get install -y wget
cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-management-server_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_8.0.31-1ubuntu22.04_amd64.deb

sudo mkdir /var/lib/mysql-cluster
curl 
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
sudo pkill -f ndb_mgmd
sudo nano /etc/systemd/system/ndb_mgmd.service

