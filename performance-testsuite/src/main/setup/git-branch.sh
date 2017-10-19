#!/usr/bin/env bash
# script used in a terraform external data resource
# needs to output json, ex. '{"branch": "master"}'
# expects git and jq are on the path
set -e
# symbolic-ref may fail if we are detached HEAD; hide stderr and fall back to name-rev
branch=`git symbolic-ref --short HEAD 2> /dev/null || git describe --always`
jq -n --arg branch "${branch}" '{"branch":$branch}'
