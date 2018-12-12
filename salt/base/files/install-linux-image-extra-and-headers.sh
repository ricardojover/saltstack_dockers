#!/bin/bash
PKGS=`for i in $( ls /boot/vmlinuz-* | sed s~.*vmlinuz-~~ ) ; do printf "linux-image-extra-$i linux-headers-$i linux-image-extra-virtual" ; done`
for package in ${PKGS[@]}; do
  if [ ! -z "`apt -qq list $package 2>/dev/null`" ]; then
    apt-get install -y $package
  fi
done

