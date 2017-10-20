#!/usr/bin/env bash

with_backoff() {
  max_attempts=${ATTEMPTS-6}
  timeout=2
  attempt=1
  exitCode=0

  while [ $attempt -le $max_attempts ]
  do
    "$@"
    exitCode=$?

    if [ $exitCode = 0 ]
    then
      break
    fi

    echo "  attempt $attempt failed, retrying in $timeout seconds..." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [ $exitCode != 0 ]
  then
    echo "Exceeded max attempts ($max_attempts) for command ($@), giving up." 1>&2
  fi

  return $exitCode
}

host=`jq -r '.node_public_dns.value[0]' target/terraformOutput.json`
echo "waiting for $host:8080..."
with_backoff nc -w 1 -z $host 8080

if [ $? -eq 0 ]
then
  echo "$host:8080 is available"
else
  exit 1
fi
