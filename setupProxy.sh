apt-get update 
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y python3-venv
apt-get install -y python-dev
apt-get install -y virtualenv

apt-get install -y nginx
mkdir flask_application
cd flask_application
virtualenv venv
source venv/bin/activate
pip install flask
pip install gunicorn
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/proxyFlaskApp.py> my_app.py
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/flaskapp.service>/etc/systemd/system/flaskapp.service
systemctl daemon-reload
systemctl start flaskapp
systemctl enable flaskapp

systemctl start nginx
systemctl enable nginx
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/default> /etc/nginx/sites-available/default
systemctl restart nginx