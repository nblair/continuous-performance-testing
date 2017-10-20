#!/usr/bin/env bash

show_help() {
cat << EOM
Usage: ${0##*/} [-h]
Configure the gatling simulation. Produces configuration file at ../src/test/resources/application.conf.

Expects:
  * terraform to be on the PATH
  * jq to be on the PATH
  * terraform state to be present in the parent directory (../ relative to this script).

    -h           display this help and exit
    -c COUNT     length of the randomly generated sample names
    -d DURATION  how long to execute each simulation, as a Scala duration (e.g. "4 minutes", "90 seconds", "2 hours")
    -m RAMP      how long to ramp up thread count, as a Scala duration (default is "1 minute")
    -t THREADS   how many concurrent clients to run (default is 16)
EOM
}

count=12
duration="2 minutes"
ramp="10 seconds"
threads=4

while getopts ":h:c:d:m:t:" opt
do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    c)
        count=$OPTARG
        ;;
    d)
        duration=$OPTARG
        ;;
    m)
        ramp=$OPTARG
        ;;
    t)
        threads=$OPTARG
        ;;
    *)
        echo "$opt, $OPTARG"
        show_help >&2
        exit 1
        ;;
    esac
done

# root ourselves where the script is so that relative paths work
cd "$(dirname "$0")"

NODE_IP=`terraform output -json | jq '.node_public_dns.value[0]' | tr -d '"'`

cat << EOF
creating gatling configuration using:
 host: $NODE_IP
 thread count: $threads
 sample name length: $count
 simulation ramp time: $ramp
 duration: $duration
EOF
sed -e "s/\${host}/$NODE_IP/" \
  -e "s/\${sampleNameSize}/$count/" \
  -e "s/\${duration}/$duration/" \
  -e "s/\${ramp}/$ramp/" \
  -e "s/\${threads}/$threads/" \
  src/test/resources/application-template.conf > src/test/resources/application.conf
