#!/bin/sh
echo " IP Address:    " $(hostname -I)
/usr/sbin/xrdp -nodaemon
