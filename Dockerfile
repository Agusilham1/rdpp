# Use the official Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server openssh-client && \
    apt-get clean

# Create the SSH directory and set permissions
RUN mkdir /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Copy the start.sh script to the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the SSH port
EXPOSE 22

# Use the start.sh script as the container's command
CMD ["/start.sh"]
