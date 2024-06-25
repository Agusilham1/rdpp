#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Print container's IP address
if command -v ip > /dev/null 2>&1; then
    ip addr show eth0 | grep "inet\b" | awk '{print "Container IP: " $2}' | cut -d/ -f1
else
    echo "ip command not found"
fi

# Keep the container running
tail -f /dev/null
