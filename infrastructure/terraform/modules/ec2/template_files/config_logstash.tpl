#!/bin/bash
echo " - starting logstash pipeline configuration steps"  >> /tmp/logstash_bootstrap.txt

## set up aws cli so we can use s3
apt-get update && apt-get install -y unzip zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo " - installed aws cli version: " >> /tmp/logstash_bootstrap.txt
aws --version >> /tmp/logstash_bootstrap.txt

## download the pipeline config files from s3 terraformstatebucket-{env}/deploy_logstash/config_files_{env}
aws s3 cp s3://${logstash_tf_bucket}/${logstash_config_prefix} ${dir_for_config_files} --recursive --exclude "*" --include "*.conf"
if [ -f /etc/logstash/conf.d/*.conf ]; then
    echo " - successfully downloaded logstash config files" >> /tmp/logstash_bootstrap.txt
else
    echo " - !failed to download logstash config files, configuration failed!" >> /tmp/logstash_bootstrap.txt
    exit 1
fi

## change owner on all logstash dirs
chown -R logstash:root /var/log/logstash
chown -R logstash:logstash /usr/share/logstash
chown -R logstash:logstash /etc/logstash
echo " - changed owner on logstash directories" >> /tmp/logstash_bootstrap.txt

## restart the service
systemctl restart logstash
echo " - restarted logstash service" >> /tmp/logstash_bootstrap.txt
