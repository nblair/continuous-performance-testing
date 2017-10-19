#!/bin/bash -e

# configure user, directories and permissions
useradd -r -u 200 -m -c "app role account" -d ${APP_DIR} -s /bin/false app

mkdir -p ${APP_DIR}/logs
mkdir -p ${APP_DIR}/data

chown -R app:app ${APP_DIR}

echo "app hard nofile 65536" >> /etc/security/limits.conf
echo "app soft nofile 65536" >> /etc/security/limits.conf
