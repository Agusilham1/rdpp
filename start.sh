#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Print container's IP address
ip addr show eth0 | grep "inet\b" | awk '{print "Container IP: " $2}' | cut -d/ -f1

# Keep the container running
tail -f /dev/null
