#!/usr/bin/env bash

cp /home/ec2-user/app-*.jar /opt/app

mkdir -p /opt/app/etc
cp /home/ec2-user/setup/config/application.yml /opt/app/etc/application.yml
