#installing sysbench

sudo apt-get update
sudo apt-get -y install sysbench
sysbench --db-driver=mysql --mysql-user=user --mysql_password=password --mysql-db=sakila --mysql-host=172.31.19.71 --mysql-port=1186 --tables=23 --threads=4 --time=0 --events=0 --report-interval=1 /usr/share/sysbench/oltp_read_write.lua run