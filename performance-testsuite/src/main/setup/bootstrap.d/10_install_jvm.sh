#!/bin/bash -e

JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=152
JAVA_VERSION_BUILD=16
JAVA_DOWNLOAD_HASH=aa0333dd3019491ca4f6ddbe78cdb6d0

# download and install java
mkdir -p /opt
curl --fail --silent --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DOWNLOAD_HASH}/server-jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
  | gunzip \
  | tar -x -C /opt
ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/java
