#!/bin/bash

echo " - starting cloudwatch agent setup steps"  >> /tmp/logstash_bootstrap.txt

## install cloudwatch agent package
cd /tmp
wget https://s3.${region}.amazonaws.com/amazoncloudwatch-agent-${region}/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

## download the cloudwatch agent config file from s3 terraformstatebucket-{env}/deploy_logstash/config_files_{env}
aws s3 cp s3://${logstash_tf_bucket}/${logstash_config_prefix} ${dir_for_cwa_files} --recursive --exclude "*" --include "*.json"
if [ -f /opt/aws/amazon-cloudwatch-agent/bin/config.json ]; then
    echo " - successfully downloaded cloudwatch agent config file" >> /tmp/logstash_bootstrap.txt
else
    echo " - !failed to download cloudwatch agent config file, configuration failed!" >> /tmp/logstash_bootstrap.txt
    exit 1
fi

## restart the service with the config file 
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
