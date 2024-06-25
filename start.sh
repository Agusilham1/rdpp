#!/bin/bash

# Create the SSH directory and set permissions
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Generate RSA key pair if it does not exist
if [ ! -f /root/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

# Start the SSH service
/usr/sbin/sshd -D
