#!/bin/bash

cd "$(dirname "$0")"

export MY_PUBLIC_IP=`jq -r '.ip' bootstrap.json`
export BRANCH=`jq -r '.branch' bootstrap.json`
export JAVA_MIN_MEM=`jq -r '.ms' bootstrap.json`
export JAVA_MAX_MEM=`jq -r '.mx' bootstrap.json`

export APP_DIR=/opt/app

for SCRIPT in bootstrap.d/*.sh; do
    $SCRIPT
done