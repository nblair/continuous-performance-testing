#!/bin/bash -e

# mount the EBS device at /opt/app
check=`file -s /dev/xvdh | awk '{print $2}'`
if [ "$check" == "data" ]; then
  # no filesystem present, make ext4 fs
  mkfs -t ext4 /dev/xvdh
fi
mkdir ${APP_DIR}
mount -o defaults,nofail /dev/xvdh ${APP_DIR}