#!/bin/bash
rm -rf /tmp/* /root/install-linux-image-extra-and-headers.sh 

LOGS=`find /var/log -type f -name \*z -o -name \*0`
for log in ${LOGS[@]}; do
  rm -f $log
done

LOGS=`find /var/log -type f`
for log in ${LOGS[@]}; do
  truncate -s 0 $log
done

