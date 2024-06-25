FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update \
    && apt-get install -y \
        wget \
        curl \
        gzip \
        ntfs-3g \
        dos2unix \
        iproute2 \
    && rm -rf /var/lib/apt/lists/*

ENV PILIHOS_URL="https://files.sowan.my.id/windows2019.gz"
ENV IFACE="Ethernet Instance 0 2"
ENV PASSADMIN="sidowayah123"

RUN mkdir -p /tmp

RUN echo '@ECHO OFF\n\
cd.>%windir%\\GetAdmin\n\
if exist %windir%\\GetAdmin (del /f /q "%windir%\\GetAdmin") else (\n\
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\\Admin.vbs"\n\
"%temp%\\Admin.vbs"\n\
del /f /q "%temp%\\Admin.vbs"\n\
exit /b 2)\n\
net user Administrator '"$PASSADMIN"'\n\
\n\
netsh -c interface ip set address name="'"$IFACE"'" source=static address=$(curl -4 -s icanhazip.com) mask=255.255.240.0 gateway=$(ip route | awk '/default/ { print $3 }')\n\
netsh -c interface ip add dnsservers name="'"$IFACE"'" address=1.1.1.1 index=1 validate=no\n\
netsh -c interface ip add dnsservers name="'"$IFACE"'" address=8.8.4.4 index=2 validate=no\n\
\n\
cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"\n\
del /f /q net.bat\n\
exit\n' > /tmp/net.bat

RUN echo '@ECHO OFF\n\
echo JENDELA INI JANGAN DITUTUP\n\
echo SCRIPT INI AKAN MERUBAH PORT RDP MENJADI 5000, SETELAH RESTART UNTUK MENYAMBUNG KE RDP GUNAKAN ALAMAT $(curl -4 -s icanhazip.com):5000\n\
echo KETIK YES LALU ENTER!\n\
\n\
cd.>%windir%\\GetAdmin\n\
if exist %windir%\\GetAdmin (del /f /q "%windir%\\GetAdmin") else (\n\
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\\Admin.vbs"\n\
"%temp%\\Admin.vbs"\n\
del /f /q "%temp%\\Admin.vbs"\n\
exit /b 2)\n\
\n\
set PORT=5000\n\
set RULE_NAME="Open Port %PORT%"\n\
\n\
netsh advfirewall firewall show rule name=%RULE_NAME% >nul\n\
if not ERRORLEVEL 1 (\n\
    rem Rule %RULE_NAME% already exists.\n\
    echo Hey, you already got a out rule by that name, you cannot put another one in!\n\
) else (\n\
    echo Rule %RULE_NAME% does not exist. Creating...\n\
    netsh advfirewall firewall add rule name=%RULE_NAME% dir=in action=allow protocol=TCP localport=%PORT%\n\
)\n\
\n\
reg add "HKLM\\System\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp" /v PortNumber /t REG_DWORD /d 5000\n\
\n\
ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\\diskpart.extend"\n\
ECHO EXTEND >> "%SystemDrive%\\diskpart.extend"\n\
START /WAIT DISKPART /S "%SystemDrive%\\diskpart.extend"\n\
\n\
del /f /q "%SystemDrive%\\diskpart.extend"\n\
cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"\n\
del /f /q dpart.bat\n\
timeout 50 >nul\n\
del /f /q ChromeSetup.exe\n\
echo JENDELA INI JANGAN DITUTUP\n\
exit\n' > /tmp/dpart.bat

RUN wget --no-check-certificate -O- $PILIHOS_URL | gunzip | dd of=/dev/vda bs=3M status=progress

RUN mount.ntfs-3g /dev/vda2 /mnt && \
    cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/" && \
    cd Start* || cd start* && \
    wget https://nixpoin.com/ChromeSetup.exe && \
    cp -f /tmp/net.bat net.bat && \
    cp -f /tmp/dpart.bat dpart.bat

RUN echo 'Your server will turn off in 3 seconds' && sleep 3 && poweroff

CMD ["/bin/bash"]
