#!/usr/bin/env bash

errors=`grep ERROR target/log/application.log | wc -l`
if [ "$errors" -gt "0" ]; then
   echo "errors detected in application log";
   exit 1;
fi
