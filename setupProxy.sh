sudo apt-get update 
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-venv
sudo apt-get install -y python-dev
sudo apt-get install -y virtualenv

sudo apt-get install -y nginx
mkdir flask_application
cd flask_application
virtualenv venv
source venv/bin/activate
pip install flask
pip install gunicorn
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/proxyFlaskApp.py> my_app.py

# sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/flaskapp.service> /etc/systemd/system/flaskapp.service
echo \"[Unit]
Description=Gunicorn instance for a simple flask app
After=network.target

[Service]
User=admin
WorkingDirectory=/flask_application
ExecStart=/flask_application/venv/bin/gunicorn -b localhost:8080 my_app:app
Restart=always

[Install]
WantedBy=multi-user.target\"> /etc/systemd/system/flaskapp.service
sudo systemctl daemon-reload
sudo systemctl start flaskapp
sudo systemctl enable flaskapp

sudo systemctl start nginx
sudo systemctl enable nginx
sudo curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/default> /etc/nginx/sites-available/default
sudo systemctl restart nginx