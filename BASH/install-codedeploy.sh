# https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
# Variables
proxyip=255.255.255.255
proxyport=12345
bucket-name=aws-codedeploy-us-gov-west-1
region-identifier=us-gov-west-1

# Script
export http_proxy="http://"$proxyip":"$proxyport"/"
export https_proxy="http://"$proxyip":"$proxyport"/"
sudo yum update
sudo yum install ruby
sudo yum install wget
cd /home/ec2-user
curl -O "https://"$bucket-name".s3."$region-identifier".amazonaws.com/latest/install
chmod +x ./install
sudo ./install --proxy "http://"$proxyip":"$proxyport"/" auto
sudo service codedeploy-agent status
