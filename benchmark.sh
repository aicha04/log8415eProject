#!/bin/bash
#installing sysbench
echo "installing sysbench" >> /var/log/user-data.log
sudo apt-get update
sudo apt-get -y install sysbench
echo "setup of benchmark is done" >> /var/log/user-data.log
# sysbench --db-driver=mysql --mysql-user=user --mysql_password=password --mysql-db=sakila --mysql-host=172.31.22.90 --mysql-port=3306 --tables=23 --table-size=10000 /usr/share/sysbench/oltp_read_write.lua prepare
# sysbench --db-driver=mysql --mysql-user=user --mysql_password=password --mysql-db=sakila --mysql-host=172.31.22.90 --mysql-port=3306 --tables=23 --threads=4 --time=0 --events=0 --report-interval=1 /usr/share/sysbench/oltp_read_write.lua run
