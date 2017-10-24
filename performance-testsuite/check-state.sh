#!/usr/bin/env bash

errors=`grep ERROR target/log/application.log | wc -l`
if [ "$errors" -gt "0" ]; then
  echo "errors detected in application log";
  exit 1;
else
  echo "no errors found in log"
fi

datasize=`jq '. | length' target/log/export.json`
if [ "$datasize" -gt "10" ]; then
  echo "datasize ($datasize) is unexpectedly large";
  exit 1;
else
  echo "datasize ($datasize) test passes"
fi
