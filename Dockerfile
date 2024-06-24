# Gunakan image dasar Debian
FROM debian:latest

# Update paket dan instal dependensi yang diperlukan
RUN apt-get update && \
    apt-get install -y wget gdebi-core

# Download dan instal Google Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    gdebi -n chrome-remote-desktop_current_amd64.deb && \
    rm chrome-remote-desktop_current_amd64.deb

# Set lingkungan DISPLAY
ENV DISPLAY=

# Salin script start-host ke dalam container
COPY start-host.sh /opt/google/chrome-remote-desktop/

# Buat script start-host.sh
RUN echo '#!/bin/bash\n/opt/google/chrome-remote-desktop/start-host --code="4/0ATx3LY7ZYRTIVs9IqLHLnXccabEnhz-ABm81XZjzsWTZDJZAWbwLDslMdMO_bUAy0AhB1w" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)' > /opt/google/chrome-remote-desktop/start-host.sh

# Jadikan script executable
RUN chmod +x /opt/google/chrome-remote-desktop/start-host.sh

# Perintah untuk menjalankan script saat container dimulai
CMD ["/opt/google/chrome-remote-desktop/start-host.sh"]
