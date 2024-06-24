# Gunakan image dasar Ubuntu
FROM ubuntu:20.04

# Atur lingkungan non-interaktif untuk mencegah prompt interaktif
ENV DEBIAN_FRONTEND=noninteractive

# Update sistem dan install dependencies yang diperlukan
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils && \
    apt-get install -y xrdp net-tools && \
    apt-get clean

# Konfigurasi xrdp untuk menggunakan sesi xfce4
RUN echo xfce4-session >~/.xsession

# Tambahkan pengguna baru dan atur passwordnya
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Konfigurasi xrdp untuk menggunakan startwm.sh
RUN sed -i.bak '/fi/a #xrdp multiple users configuration\n\
    xfce4-session\n\
    ' /etc/xrdp/startwm.sh

# Buka port 3389 untuk RDP
EXPOSE 3389

# Salin skrip start ke dalam container
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Gunakan skrip start.sh sebagai perintah default
CMD ["/usr/local/bin/start.sh"]
