#!/usr/bin/env bash

# root ourselves where the script is so that relative paths work
cd "$(dirname "$0")"

# send a request to export the local dataset, will leave a file in the logs directory
ip=`jq -r .node_public_dns.value[] target/terraformOutput.json`
curl -X POST http://$ip:8080/sample/export

jq -r .ssh_key.value target/terraformOutput.json > target/test-key
chmod 600 target/test-key

mkdir -p target/log
for DNS_NAME in $(jq -r .node_public_dns.value[] target/terraformOutput.json); do
    SSH_OPTS="-o StrictHostKeyChecking=no -i target/test-key ec2-user@${DNS_NAME}"
    echo "recovering log archive from $DNS_NAME"
    ssh ${SSH_OPTS} "sudo tar -czf - -C /opt/app log" > target/logs-${DNS_NAME}.tgz
    tar -xzf target/logs-${DNS_NAME}.tgz -C target
done

