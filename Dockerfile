# Use the official Ubuntu 20.04 as a base image
FROM ubuntu:20.04
 
# Set environment variables to non-interactive for automatic installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server iproute2 && \
    mkdir /var/run/sshd

# Add the public key to the root user's authorized_keys
RUN mkdir -p /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaoDAGLqrmqYtP8W/S+kVrUzXnbOS+0MBj53T997T2/xoaJnQarfn2fVnNK1Jr3+RCeV02877htGpU2xDHyzieo0qP1RCLiRv7QUCmvizWvhwjFo9q1HJdNwSL9Y3u35MK7V9OHPRLDLC7lI9GkEKydt3/QdaOHpZ6sgnCRLXGS/wBsARHUiFHGPSubqNs1Ub+tAyx+6FgJ/ZkRTInX/kuMh/G30qJhj3+kJ04VlQ4CeCr/Gsnod8SLkacu7dINqqk+rbTuAFdpCssnfT6HML4gnzfqSSiN74fyAYmteJg5VFfpFb6bcV0q72Xz3X40CTlQX1lOrXNjW/FypksAE4D" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root/.ssh/authorized_keys

# Copy the start script into the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Run the start script
CMD ["/start.sh"]
