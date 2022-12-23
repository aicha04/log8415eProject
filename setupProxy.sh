#!/bin/bash
echo "setting up proxy" >> /var/log/user-data.log
echo "installing python and nginx" >> /var/log/user-data.log
sudo apt-get update 
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-venv
sudo apt-get install -y python-dev
sudo apt-get install -y virtualenv
sudo apt-get install -y nginx
echo "installing flask and gunicorn in venv" >> /var/log/user-data.log
mkdir flask_application
cd flask_application
virtualenv venv
source venv/bin/activate
pip install flask
pip install gunicorn
pip install MySQL-python
pip install MySQL-python-connector
echo "creating glask app" >> /var/log/user-data.log
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/proxyFlaskApp.py> my_app.py
echo "downloading flasapp.service" >> /var/log/user-data.log
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/flaskapp.service> /etc/systemd/system/flaskapp.service
echo "starting flaskapp" >> /var/log/user-data.log

sudo systemctl daemon-reload
sudo systemctl start flaskapp
sudo systemctl enable flaskapp
echo "starting nginx" >> /var/log/user-data.log
sudo systemctl start nginx
sudo systemctl enable nginx
echo "downloading default available sites glask app" >> /var/log/user-data.log
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/default> /etc/nginx/sites-available/default
echo "restarting nginx" >> /var/log/user-data.log
sudo systemctl restart nginx
echo "setup of proxy ended" >> /var/log/user-data.log

