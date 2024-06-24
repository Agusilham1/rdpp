# Base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    dbus-x11 \
    xfce4 \
    xrdp \
    python3-xdg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb \
    && dpkg -i chrome-remote-desktop_current_amd64.deb \
    && apt-get install -f -y \
    && rm chrome-remote-desktop_current_amd64.deb

# Configure Chrome Remote Desktop
COPY crd-start.sh /usr/local/bin/crd-start.sh
RUN chmod +x /usr/local/bin/crd-start.sh

# Expose port
EXPOSE 3389

# Start Chrome Remote Desktop
CMD ["crd-start.sh"]
