#!/bin/bash -e

#export JAVA_OPTS="-Xmx=${JAVA_MAX_MEM} -Xms=${JAVA_MIN_MEM} -Djava.rmi.server.hostname=${MY_PUBLIC_IP}"

cd /opt/app && \
  su app -s /bin/bash -c "/opt/java/bin/java -jar app-*.jar server etc/application.yml &"
