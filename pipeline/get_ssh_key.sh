#!/bin/bash

# create the ~/.ssh key file from secrets manager secret
aws secretsmanager get-secret-value --region us-east-1 --secret-id SSHKEY-company/logstash_server_pem | jq --raw-output '.SecretString' > ~/.ssh/logstash_server_key
