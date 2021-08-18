# Variables
newuser=nginx
# Script
sudo service codedeploy-agent stop 
sudo sed -i 's/""/"$newuser"/g' /etc/init.d/codedeploy-agent 
sudo sed -i 's/#User=codedeploy/User=$newuser/g' /usr/lib/systemd/system/codedeploy-agent.service 
sudo chown $newuser:$newuser -R /opt/codedeploy-agent/ 
sudo chown $newuser:$newuser -R /var/log/aws/ 
sudo chown $newuser:$newuser -R /var/www/ 
sudo service codedeploy-agent start 
sudo service codedeploy-agent status 
ps aux | grep codedeploy-agent 
