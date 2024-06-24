#!/bin/sh
echo "Container IP Address:" $(hostname -I)
/usr/sbin/xrdp -nodaemon
