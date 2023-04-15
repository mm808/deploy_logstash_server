#!/bin/bash

touch /tmp/logstash_bootstrap.txt

curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt update
apt-get install logstash
systemctl enable logstash.service
echo "  - installed updates, gpg key and logstash. "  >> /tmp/logstash_bootstrap.txt

cd /usr/share/logstash
bin/logstash-plugin install --no-verify logstash-output-opensearch >> /tmp/logstash_bootstrap.txt
echo "  - installed logstash-output-opensearch plugin. "  >> /tmp/logstash_bootstrap.txt
